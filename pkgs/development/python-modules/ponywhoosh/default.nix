{
  lib,
  buildPythonPackage,
  fetchPypi,
  pony,
  whoosh,
}:

buildPythonPackage rec {
  pname = "ponywhoosh";
  version = "1.7.8";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mggj9d265hra4z67qyla686qvl0cf79655cszi136gh9hqlibv9";
  };

  propagatedBuildInputs = [
    pony
    whoosh
  ];

  meta = with lib; {
    homepage = "https://pythonhosted.org/ponywhoosh/";
    description = "Make your database over PonyORM searchable";
    license = licenses.mit;
    maintainers = with maintainers; [ alexarice ];
  };
}
