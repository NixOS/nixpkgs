{ lib
, buildPythonPackage
, fetchFromGitHub
, looseversion
, mmtf-python
, nose
, numpy
, pandas
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "biopandas";
  version = "0.4.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "BioPandas";
    repo = "biopandas";
    rev = "refs/tags/v${version}";
    hash = "sha256-PRdemBo+bB2xJWmF2NylFTfNwEEo67i6XSaeDAFmQ/c=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "looseversion"
  ];

  propagatedBuildInputs = [
    numpy
    pandas
    mmtf-python
    looseversion
  ];

  nativeCheckInputs = [
    nose
  ];

  checkPhase = ''
    runHook preCheck

    nosetests

    runHook postCheck
  '';

  pythonImportsCheck = [
    "biopandas"
  ];

  meta = {
    description = "Working with molecular structures in pandas DataFrames";
    homepage = "https://github.com/BioPandas/biopandas";
    changelog = "https://github.com/BioPandas/biopandas/releases/tag/${src.rev}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
