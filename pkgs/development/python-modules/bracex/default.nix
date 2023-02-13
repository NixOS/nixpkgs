{ lib
, buildPythonPackage
, fetchPypi
, hatchling
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "bracex";
  version = "2.3.post1";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-57I/yLLNBtPewGkrqr7LJJ3alOBqYXkB/wOmxW/XFpM=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "bracex" ];

  meta = with lib; {
    description = "Bash style brace expansion for Python";
    homepage = "https://github.com/facelessuser/bracex";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
