{ lib
, buildPythonPackage
, fetchFromGitHub
, importlib-metadata
, numpy
, pybind11
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "pyfma";
  version = "0.1.6";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nschloe";
    repo = pname;
    rev = version;
    sha256 = "12i68jj9n1qj9phjnj6f0kmfhlsd3fqjlk9p6d4gs008azw5m8yn";
  };

  nativeBuildInputs = [
    setuptools
  ];

  buildInputs = [
    pybind11
  ];

  propagatedBuildInputs = [
    numpy
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  nativeCheckInputs = [
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
