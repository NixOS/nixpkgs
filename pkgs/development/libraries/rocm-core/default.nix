{ lib
, stdenv
, fetchFromGitHub
, runCommand
, substituteAll
, cmake
}:

let
  rocm_version = with lib; concatStrings (intersperse "0" (splitString "." stdenv.cc.version));
in stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-core";
  version = stdenv.cc.version;

  # Based on https://github.com/rocm-arch/rocm-arch/tree/ad0b15690d403e5822db062ffff4db3912de6669/rocm-core
  src = let
    rocm_major = lib.versions.major finalAttrs.version;
    rocm_minor = lib.versions.minor finalAttrs.version;
    rocm_patch = lib.versions.patch finalAttrs.version;

    cmake_lists = substituteAll {
      inherit rocm_version;
      src = ./src/CMakeLists.txt;
    };

    version_c = substituteAll {
      inherit rocm_major rocm_minor rocm_patch;
      src = ./src/rocm_version.c;
    };

    version_h = substituteAll {
      inherit rocm_major rocm_minor rocm_patch;
      src = ./src/rocm_version.h;
    };
  in runCommand "rocm-core-${finalAttrs.version}-source" { preferLocalBuild = true; } ''
    mkdir -p $out/rocm-core
    ln -s ${cmake_lists} $out/CMakeLists.txt
    ln -s ${version_c} $out/rocm_version.c
    ln -s ${version_h} $out/rocm-core/rocm_version.h
  '';

  nativeBuildInputs = [ cmake ];

  postInstall = ''
    mkdir -p $out/include
    cp -a ../rocm-core $out/include
    ln -s $out/include/rocm-core/rocm_version.h $out/include
    ln -s $out/lib/librocm-core.so.1.0.${rocm_version} $out/lib/librocm-core.so.1
  '';

  meta = with lib; {
    description = "ROCm core";
    homepage = "https://docs.amd.com";
    license = with licenses; [ ncsa ]; # See src/rocm_version.h
    maintainers = teams.rocm.members;
  };
})
