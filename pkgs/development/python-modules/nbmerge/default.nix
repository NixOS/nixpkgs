{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, nbformat
, nose
}:

buildPythonPackage rec {
  pname = "nbmerge";
  version = "0.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jbn";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Uqs/SO/AculHCFYcbjW08kLQX5GSU/eAwkN2iy/vhLM=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [ nbformat ];

  nativeCheckInputs = [ nose ];

  checkPhase = ''
    runHook preCheck

    patchShebangs .
    nosetests -v
    PATH=$PATH:$out/bin ./cli_tests.sh

    runHook postCheck
  '';

  pythonImportsCheck = [
    "nbmerge"
  ];

  meta = {
    description = "A tool to merge/concatenate Jupyter (IPython) notebooks";
    inherit (src.meta) homepage;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "nbmerge";
  };
}
