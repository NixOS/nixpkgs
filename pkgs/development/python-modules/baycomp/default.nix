{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, setuptools
, setuptools-scm
, matplotlib
, numpy
, scipy
}:

buildPythonPackage rec {
  pname = "baycomp";
  version = "1.0.2";
  format = "setuptools";
  disabled = pythonOlder "3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xDRywWvXzfSITdTHPdMH5KPacJf+Scg81eiNdRQpI7A=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    matplotlib
    numpy
    scipy
  ];

  pythonImportsCheck = [ "baycomp" ];

  doCheck = true;

  meta = with lib; {
    description = "A library for Bayesian comparison of classifiers";
    homepage = "https://baycomp.readthedocs.io";
    changelog = "https://github.com/janezd/baycomp/releases/tag/v${version}";
    downloadPage = "https://pypi.org/project/baycomp/#files";
    license = licenses.mit;
    maintainers = with maintainers; [ totoroot ];
  };
}
