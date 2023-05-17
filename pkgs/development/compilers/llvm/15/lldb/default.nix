{ lib, stdenv, llvm_meta
, runCommand
, monorepoSrc
, cmake
, ninja
, zlib
, ncurses
, swig
, which
, libedit
, libxml2
, libllvm
, libclang
, python3
, version
, libobjc
, xpc
, Foundation
, bootstrap_cmds
, Carbon
, Cocoa
, lit
, makeWrapper
, darwin
, enableManpages ? false
, lua5_3
}:

# TODO: we build the python bindings but don't expose them as a python package
# TODO: expose the vscode extension?

stdenv.mkDerivation (rec {
  pname = "lldb";
  inherit version;

  src = runCommand "${pname}-src-${version}" {} ''
    mkdir -p "$out"
    cp -r ${monorepoSrc}/cmake "$out"
    cp -r ${monorepoSrc}/${pname} "$out"
  '';

  sourceRoot = "${src.name}/${pname}";

  patches = [
    ./procfs.patch
    (runCommand "resource-dir.patch" {
      clangLibDir = "${libclang.lib}/lib";
    } ''
      substitute '${./resource-dir.patch}' "$out" --subst-var clangLibDir
    '')
    ./gnu-install-dirs.patch
  ]
  # This is a stopgap solution if/until the macOS SDK used for x86_64 is
  # updated.
  #
  # The older 10.12 SDK used on x86_64 as of this writing has a `mach/machine.h`
  # header that does not define `CPU_SUBTYPE_ARM64E` so we replace the one use
  # of this preprocessor symbol in `lldb` with its expansion.
  #
  # See here for some context:
  # https://github.com/NixOS/nixpkgs/pull/194634#issuecomment-1272129132
  ++ lib.optional (
    stdenv.targetPlatform.isDarwin
      && !stdenv.targetPlatform.isAarch64
      && (lib.versionOlder darwin.apple_sdk.sdk.version "11.0")
  ) ./cpu_subtype_arm64e_replacement.patch;

  outputs = [ "out" "lib" "dev" ];

  nativeBuildInputs = [
    cmake ninja python3 which swig lit makeWrapper lua5_3
  ] ++ lib.optionals enableManpages [
    python3.pkgs.sphinx python3.pkgs.recommonmark
  ];

  buildInputs = [
    ncurses
    zlib
    libedit
    libxml2
    libllvm
  ] ++ lib.optionals stdenv.isDarwin [
    libobjc
    xpc
    Foundation
    bootstrap_cmds
    Carbon
    Cocoa
  ]
  # The older libSystem used on x86_64 macOS is missing the
  # `<bsm/audit_session.h>` header which `lldb` uses.
  #
  # We copy this header over from macOS 10.12 SDK.
  #
  # See here for context:
  # https://github.com/NixOS/nixpkgs/pull/194634#issuecomment-1272129132
  ++ lib.optional (
      stdenv.targetPlatform.isDarwin
        && !stdenv.targetPlatform.isAarch64
    ) (
      runCommand "bsm-audit-session-header" { } ''
        install -Dm444 \
          "${lib.getDev darwin.apple_sdk.sdk}/include/bsm/audit_session.h" \
          "$out/include/bsm/audit_session.h"
      ''
    );

  hardeningDisable = [ "format" ];

  cmakeFlags = [
    "-DLLDB_INCLUDE_TESTS=${if doCheck then "YES" else "NO"}"
    "-DLLVM_ENABLE_RTTI=OFF"
    "-DClang_DIR=${libclang.dev}/lib/cmake"
    "-DLLVM_EXTERNAL_LIT=${lit}/bin/lit"
  ] ++ lib.optionals stdenv.isDarwin [
    "-DLLDB_USE_SYSTEM_DEBUGSERVER=ON"
  ] ++ lib.optionals (!stdenv.isDarwin) [
    "-DLLDB_CODESIGN_IDENTITY=" # codesigning makes nondeterministic
  ] ++ lib.optionals enableManpages [
    "-DLLVM_ENABLE_SPHINX=ON"
    "-DSPHINX_OUTPUT_MAN=ON"
    "-DSPHINX_OUTPUT_HTML=OFF"

    # docs reference `automodapi` but it's not added to the extensions list when
    # only building the manpages:
    # https://github.com/llvm/llvm-project/blob/af6ec9200b09039573d85e349496c4f5b17c3d7f/lldb/docs/conf.py#L54
    #
    # so, we just ignore the resulting errors
    "-DSPHINX_WARNINGS_AS_ERRORS=OFF"
  ] ++ lib.optionals doCheck [
    "-DLLDB_TEST_C_COMPILER=${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc"
    "-DLLDB_TEST_CXX_COMPILER=${stdenv.cc}/bin/${stdenv.cc.targetPrefix}c++"
  ];

  doCheck = false;

  installCheckPhase = ''
    if [ ! -e "$lib/${python3.sitePackages}/lldb/_lldb.so" ] ; then
        return 1;
    fi
  '';

  postInstall = ''
    wrapProgram $out/bin/lldb --prefix PYTHONPATH : $lib/${python3.sitePackages}/

    # Editor support
    # vscode:
    install -D ../tools/lldb-vscode/package.json $out/share/vscode/extensions/llvm-org.lldb-vscode-0.1.0/package.json
    mkdir -p $out/share/vscode/extensions/llvm-org.lldb-vscode-0.1.0/bin
    ln -s $out/bin/lldb-vscode $out/share/vscode/extensions/llvm-org.lldb-vscode-0.1.0/bin
  '';

  meta = llvm_meta // {
    homepage = "https://lldb.llvm.org/";
    description = "A next-generation high-performance debugger";
    longDescription = ''
      LLDB is a next generation, high-performance debugger. It is built as a set
      of reusable components which highly leverage existing libraries in the
      larger LLVM Project, such as the Clang expression parser and LLVM
      disassembler.
    '';
  };
} // lib.optionalAttrs enableManpages {
  pname = "lldb-manpages";

  ninjaFlags = [ "docs-lldb-man" ];

  propagatedBuildInputs = [];

  # manually install lldb man page
  installPhase = ''
    mkdir -p $out/share/man/man1
    install docs/man/lldb.1 -t $out/share/man/man1/
  '';

  postPatch = null;
  postInstall = null;

  outputs = [ "out" ];

  doCheck = false;

  meta = llvm_meta // {
    description = "man pages for LLDB ${version}";
  };
})
