{ lib, buildPythonPackage, fetchPypi
, black
, pytest
, setuptools_scm
, toml
}:

buildPythonPackage rec {
  pname = "pytest-black";
  version = "0.3.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mjxqvzadpyfvypv5isfda9c6lz8xbqci9b4hn58b2lbj3kv0pjr";
  };

  nativeBuildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [ black pytest toml ];

  pythonImportsCheck = [ "pytest_black" ];

  meta = with lib; {
    description = "A pytest plugin to enable format checking with black";
    homepage = "https://github.com/shopkeep/pytest-black";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
