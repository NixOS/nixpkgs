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
    hash = "sha256-aa9IMUzwmRHi16wUk45jgG5skFHU42M+URkWI1qS79U=";
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
