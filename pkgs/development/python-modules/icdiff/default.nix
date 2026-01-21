{
  lib,
  stdenv,
  python,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pythonAtLeast,
  writableTmpDirAsHomeHook,
  pkgs,
}:
let
  inherit (pkgs) bash git less;
in

buildPythonPackage rec {
  pname = "icdiff";
  version = "2.0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jeffkaufman";
    repo = "icdiff";
    tag = "release-${version}";
    hash = "sha256-SbgUBWaNT8akYKXYef/94vqZqJannZv+TxfbCnHKQtw=";
  };

  patches = [ ./0001-Don-t-test-black-or-flake8.patch ];

  build-system = [ setuptools ];

  pythonImportsCheck = [ "icdiff" ];

  nativeCheckInputs = [
    bash
    git
    less
    writableTmpDirAsHomeHook
  ];

  # Before the wheel gets created, fix up the shebangs.
  preBuild = ''
    patchShebangs test.sh icdiff git-icdiff
  '';

  # Odd behavior in the sandbox
  doCheck = !stdenv.hostPlatform.isDarwin;

  checkPhase = ''
    runHook preCheck

    ./test.sh ${python.interpreter}

    runHook postCheck
  '';

  meta = {
    description = "Improved colorized diff";
    homepage = "https://github.com/jeffkaufman/icdiff";
    changelog = "https://github.com/jeffkaufman/icdiff/releases/tag/release-${version}/CHANGELOG.md";
    license = lib.licenses.psfl;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
}
