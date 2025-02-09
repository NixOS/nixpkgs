{ lib
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec{
  pname = "riprova";
  version = "0.3.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-FgFySbvBjcZU2bjo40/1O7glc6oFWW05jinEOfMWMVI=";
  };

  propagatedBuildInputs = [ six ];

  # PyPI archive doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "riprova" ];

  meta = with lib; {
    homepage = "https://github.com/h2non/riprova";
    description = "Small and versatile library to retry failed operations using different backoff strategies";
    license = licenses.mit;
    maintainers = with maintainers; [ mmilata ];
  };
}
