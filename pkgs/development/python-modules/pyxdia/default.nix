{
  lib,
  stdenv,
  pkgsCross,
  buildPythonPackage,
  fetchFromGitHub,
  fetchzip,
  fetchpatch,
  pytestCheckHook,
  setuptools,
  blink,
}:
let
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "mborgerson";
    repo = "xdia";
    tag = "v${version}";
    hash = "sha256-VfA4xaszdd8ZhPdbEsawDzzl2F4tM4vk8uQIuDpULE0=";
  };

  xdia = fetchzip {
    url = "https://github.com/mborgerson/xdia/releases/download/v${version}/xdia.zip";
    hash = "sha256-/r60NLacyL92drPpligmom5Eb3wNfzTJ0M0cieu7Ouw=";
    stripRoot = false;
  };

  xdialdr =
    {
      stdenv,
      cmake,
      icu,
    }:
    stdenv.mkDerivation {
      pname = "xdialdr";
      inherit version src;

      nativeBuildInputs = [ cmake ];

      cmakeFlags = [
        (lib.cmakeFeature "CMAKE_EXE_LINKER_FLAGS" "-Wl,-z,common-page-size=65536,-z,max-page-size=65536")
      ];

      buildInputs = [ icu ];

      patches = [
        (fetchpatch {
          url = "https://aur.archlinux.org/cgit/aur.git/plain/fix-pyproject.patch?h=python-pyxdia";
          hash = "sha256-WnerNR3VRJqLNSfTgXaCmYfCfhzLXvA8dsVL46DofIM=";
        })
        (fetchpatch {
          url = "https://aur.archlinux.org/cgit/aur.git/plain/fix-cmake.patch?h=python-pyxdia";
          hash = "sha256-Hj+HYlYOCkOpNSnHjn0wHSadJSH7iNUqYLkCCtzHIsI=";
        })
      ];

      postPatch = ''
        for f in src/{pe-loader/common.h,xdia/PrintSymbol.cpp,DIA2Dump/PrintSymbol.cpp}; do
            substituteInPlace $f --replace-fail "<malloc.h>" "<stdlib.h>"
        done
      '';
    };
in
buildPythonPackage {
  pname = "pyxdia";
  inherit version src;
  pyproject = true;

  sourceRoot = "source/pyxdia";

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  preBuild = ''
    mkdir -p pyxdia/bin
    ln -s ${xdia}/{msdia140.dll,xdia.exe} pyxdia/bin/
    ln -s ${pkgsCross.musl64.pkgsStatic.callPackage xdialdr { }}/xdialdr pyxdia/bin/
  ''
  + lib.optionalString (stdenv.hostPlatform.system != "x86_64-linux") ''
    ln -s ${lib.getExe' blink "blink"} pyxdia/bin/
  '';

  preCheck = ''
    export PDB_TEST_FILES=$src/tests
  '';

  pythonImportsCheck = [ "pyxdia" ];

  meta = {
    description = "Tool to extract data from PDB files";
    homepage = "https://github.com/mborgerson/xdia";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
    license = with lib.licenses; [
      mit
      lgpl21Only
    ];
    maintainers = with lib.maintainers; [ feyorsh ];
    broken = stdenv.hostPlatform.isDarwin;
  };
}
