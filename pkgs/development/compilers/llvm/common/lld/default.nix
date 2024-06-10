{ lib
, stdenv
, llvm_meta
, release_version
, patches ? []
, buildLlvmTools
, monorepoSrc ? null
, src ? null
, libunwind ? null
, runCommand
, cmake
, ninja
, libxml2
, libllvm
, version
}:
let
  pname = "lld";
  src' =
    if monorepoSrc != null then
      runCommand "lld-src-${version}" {} ''
        mkdir -p "$out"
        cp -r ${monorepoSrc}/cmake "$out"
        cp -r ${monorepoSrc}/${pname} "$out"
        mkdir -p "$out/libunwind"
        cp -r ${monorepoSrc}/libunwind/include "$out/libunwind"
        mkdir -p "$out/llvm"
      '' else src;

  postPatch = lib.optionalString (lib.versions.major release_version == "12") ''
    substituteInPlace MachO/CMakeLists.txt --replace \
      '(''${LLVM_MAIN_SRC_DIR}/' '('
    mkdir -p libunwind/include
    tar -xf "${libunwind.src}" --wildcards -C libunwind/include --strip-components=2 "libunwind-*/include/"
  '' + lib.optionalString (lib.versions.major release_version == "13" && stdenv.isDarwin) ''
    substituteInPlace MachO/CMakeLists.txt --replace \
      '(''${LLVM_MAIN_SRC_DIR}/' '(../'
  '';
in
stdenv.mkDerivation (rec {
  inherit pname version patches;

  src = src';

  sourceRoot =
    if lib.versionOlder release_version "13" then null
    else "${src.name}/${pname}";

  nativeBuildInputs = [ cmake ] ++ lib.optional (lib.versionAtLeast release_version "15") ninja;
  buildInputs = [ libllvm libxml2 ];

  cmakeFlags = lib.optionals (lib.versionOlder release_version "14") [
    "-DLLVM_CONFIG_PATH=${libllvm.dev}/bin/llvm-config${lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) "-native"}"
  ] ++ lib.optionals (lib.versionAtLeast release_version "15") [
    "-DLLD_INSTALL_PACKAGE_DIR=${placeholder "dev"}/lib/cmake/lld"
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "-DLLVM_TABLEGEN_EXE=${buildLlvmTools.llvm}/bin/llvm-tblgen"
  ];

  # Musl's default stack size is too small for lld to be able to link Firefox.
  LDFLAGS = lib.optionalString stdenv.hostPlatform.isMusl "-Wl,-z,stack-size=2097152";

  outputs = [ "out" "lib" "dev" ];

  meta = llvm_meta // {
    homepage = "https://lld.llvm.org/";
    description = "LLVM linker (unwrapped)";
    longDescription = ''
      LLD is a linker from the LLVM project that is a drop-in replacement for
      system linkers and runs much faster than them. It also provides features
      that are useful for toolchain developers.
      The linker supports ELF (Unix), PE/COFF (Windows), Mach-O (macOS), and
      WebAssembly in descending order of completeness. Internally, LLD consists
      of several different linkers.
    '';
  };
} // (if (postPatch == "" && lib.versions.major release_version != "13") then {} else { inherit postPatch; }))
