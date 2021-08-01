{ lib
, buildPythonPackage
, fetchFromGitHub
, importlib-metadata
, numpy
, pybind11
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyfma";
  version = "0.1.4";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nschloe";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wkcl41j2d1yflc5dl30ys1yxx68w9zn3vj8brwkm1ar9jnfmg4h";
  };
  format = "pyproject";

  buildInputs = [
    pybind11
  ];

  propagatedBuildInputs = [
    numpy
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyfma" ];

  meta = with lib; {
    description = "Fused multiply-add for Python";
    homepage = "https://github.com/nschloe/pyfma";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
