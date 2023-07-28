{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
# native build inputs
, numpy
, pybind11
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "hnswlib";
  version = "0.7.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "nmslib";
    repo = "hnswlib";
    rev = "v${version}";
    hash = "sha256-XXz0NIQ5dCGwcX2HtbK5NFTalP0TjLO6ll6TmH3oflI=";
  };

  nativeBuildInputs = [
    numpy
    pybind11
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "hnswlib" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Header-only C++/python library for fast approximate nearest neighbors";
    homepage = "https://github.com/nmslib/hnswlib";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
