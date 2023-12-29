{ lib
, stdenv
, llvm_meta
, release_version
, cmake
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
, darwin
, lit
, makeWrapper
, lua5_3
, ninja
, runCommand
, src ? null
, monorepoSrc ? null
, patches ? [ ]
, enableManpages ? false
, ...
}:

let
  src' =
    if monorepoSrc != null then
      runCommand "lldb-src-${version}" { } ''
        mkdir -p "$out"
        cp -r ${monorepoSrc}/cmake "$out"
        cp -r ${monorepoSrc}/lldb "$out"
      '' else src;
in

stdenv.mkDerivation (rec {
  passthru.monorepoSrc = monorepoSrc;
  pname = "lldb";
  inherit version;

  src = src';
  inherit patches;

  outputs = [ "out" "lib" "dev" ];

  sourceRoot = lib.optional (lib.versionAtLeast release_version "13") "${src.name}/${pname}";

  nativeBuildInputs = [
    cmake
    python3
    which
    swig
    lit
    makeWrapper
    lua5_3
  ] ++ lib.optionals enableManpages [
    python3.pkgs.sphinx
    python3.pkgs.recommonmark
  ] ++ lib.optionals (lib.versionAtLeast release_version "14") [
    ninja
  ];

  buildInputs = [
    ncurses
    zlib
    libedit
    libxml2
    libllvm
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.libobjc
    darwin.apple_sdk.libs.xpc
    darwin.apple_sdk.frameworks.Foundation
    darwin.bootstrap_cmds
    darwin.apple_sdk.frameworks.Carbon
    darwin.apple_sdk.frameworks.Cocoa
  ]
  # The older libSystem used on x86_64 macOS is missing the
  # `<bsm/audit_session.h>` header which `lldb` uses.
  #
  # We copy this header over from macOS 10.12 SDK.
  #
  # See here for context:
  # https://github.com/NixOS/nixpkgs/pull/194634#issuecomment-1272129132
  ++ lib.optional
    (
      stdenv.targetPlatform.isDarwin
        && !stdenv.targetPlatform.isAarch64
        && (lib.versionAtLeast release_version "15")
    )
    (
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
    "-DClang_DIR=${lib.getDev libclang}/lib/cmake"
    "-DLLVM_EXTERNAL_LIT=${lit}/bin/lit"
  ] ++ lib.optionals stdenv.isDarwin [
    "-DLLDB_USE_SYSTEM_DEBUGSERVER=ON"
  ] ++ lib.optionals (!stdenv.isDarwin) [
    "-DLLDB_CODESIGN_IDENTITY=" # codesigning makes nondeterministic
  ] ++ lib.optionals (lib.versionAtLeast release_version "17") [
    "-DCLANG_RESOURCE_DIR=../../../../${libclang.lib}"
  ] ++ lib.optionals enableManpages ([
    "-DLLVM_ENABLE_SPHINX=ON"
    "-DSPHINX_OUTPUT_MAN=ON"
    "-DSPHINX_OUTPUT_HTML=OFF"
  ] ++ lib.optionals (lib.versionAtLeast release_version "15") [
    # docs reference `automodapi` but it's not added to the extensions list when
    # only building the manpages:
    # https://github.com/llvm/llvm-project/blob/af6ec9200b09039573d85e349496c4f5b17c3d7f/lldb/docs/conf.py#L54
    #
    # so, we just ignore the resulting errors
    "-DSPHINX_WARNINGS_AS_ERRORS=OFF"
  ]) ++ lib.optionals doCheck [
    "-DLLDB_TEST_C_COMPILER=${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc"
    "-DLLDB_TEST_CXX_COMPILER=${stdenv.cc}/bin/${stdenv.cc.targetPrefix}c++"
  ];

  doCheck = false;
  doInstallCheck = lib.versionOlder release_version "15";

  # TODO: cleanup with mass-rebuild
  installCheckPhase = ''
    if [ ! -e $lib/${python3.sitePackages}/lldb/_lldb*.so ] ; then
        echo "ERROR: python files not installed where expected!";
        return 1;
    fi
  '' # Something lua is built on older versions but this file doesn't exist.
  + lib.optionalString (lib.versionAtLeast release_version "14") ''
    if [ ! -e "$lib/lib/lua/${lua5_3.luaversion}/lldb.so" ] ; then
        echo "ERROR: lua files not installed where expected!";
        return 1;
    fi
  '';

  postInstall = ''
    wrapProgram $out/bin/lldb --prefix PYTHONPATH : $lib/${python3.sitePackages}/

    # Editor support
    # vscode:
    install -D ../tools/lldb-vscode/package.json $out/share/vscode/extensions/llvm-org.lldb-vscode-0.1.0/package.json
    mkdir -p $out/share/vscode/extensions/llvm-org.lldb-vscode-0.1.0/bin
    ln -s $out/bin/*-vscode $out/share/vscode/extensions/llvm-org.lldb-vscode-0.1.0/bin
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
    # llvm <10 never built on aarch64-darwin since first introduction in nixpkgs
    broken =
      (lib.versionOlder release_version "11" && stdenv.isDarwin && stdenv.isAarch64)
        || (((lib.versions.major release_version) == "13") && stdenv.isDarwin);
  };
} // lib.optionalAttrs enableManpages {
  pname = "lldb-manpages";

  buildPhase = lib.optionalString (lib.versionOlder release_version "15") ''
    make ${if (lib.versionOlder release_version "12") then "docs-man" else "docs-lldb-man"}
  '';


  ninjaFlags = lib.optionals (lib.versionAtLeast release_version "15") [ "docs-lldb-man" ];

  propagatedBuildInputs = [ ];

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
