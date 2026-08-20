{
  lib,
  stdenv,
  pkgsCross,
  buildPythonPackage,
  fetchFromGitHub,
  fetchzip,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  blink,
}:

let
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "mborgerson";
    repo = "xdia";
    tag = "v${version}";
    hash = "sha256-9GXRg2rMQ34OWyhRisxX3zYdrT9lWZb1byFmHKWkxVU=";
  };

  xdia = fetchzip {
    url = "https://github.com/mborgerson/xdia/releases/download/v${version}/xdia.zip";
    hash = "sha256-lPAv279asABhGWcAhimu4QCaJcZksrzgzVvolO5vlFI=";
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
      __structuredAttrs = true;

      nativeBuildInputs = [ cmake ];
      buildInputs = [ icu ];

      # pyxdia only needs the loader.
      buildPhase = ''
        runHook preBuild
        cmake --build . --target xdialdr --parallel "$NIX_BUILD_CORES"
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        install -Dm755 src/xdialdr "$out/bin/xdialdr"
        install -Dm644 ../src/xdia-loader/xdialdr.LICENSE.txt \
          "$out/share/licenses/xdialdr/xdialdr.LICENSE.txt"
        runHook postInstall
      '';
    };
in
buildPythonPackage {
  pname = "pyxdia";
  inherit version src;
  pyproject = true;
  __structuredAttrs = true;
  sourceRoot = "source/pyxdia";

  disabled = pythonOlder "3.12";

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  preBuild = ''
    mkdir -p pyxdia/bin
    ln -s ${xdia}/{msdia140.dll,xdia.exe} pyxdia/bin/
    ln -s ${pkgsCross.musl64.pkgsStatic.callPackage xdialdr { }}/bin/xdialdr pyxdia/bin/
  ''
  # xdialdr is an x86_64-linux executable; emulate it on other systems.
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
    changelog = "https://github.com/mborgerson/xdia/releases/tag/v${version}";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
    license = with lib.licenses; [
      mit
      lgpl21Only
      unfreeRedistributable
    ];
    maintainers = with lib.maintainers; [ feyorsh ];
    broken = stdenv.hostPlatform.isDarwin;
  };
}
