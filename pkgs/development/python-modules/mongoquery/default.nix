{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
  isPy27,
}:

buildPythonPackage rec {
  pname = "mongoquery";
  version = "1.4.3";
  format = "setuptools";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-6QH4buWvfvbtovLCb0vSz+g4DYHxeLfjYH27zc7pcjk=";
  };

  propagatedBuildInputs = [ six ];

  pythonImportsCheck = [ "mongoquery" ];

  meta = with lib; {
    description = "Python implementation of mongodb queries";
    homepage = "https://github.com/kapouille/mongoquery";
    license = with licenses; [ unlicense ];
    maintainers = with maintainers; [ misuzu ];
  };
}
