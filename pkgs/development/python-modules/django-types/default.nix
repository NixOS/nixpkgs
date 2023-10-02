{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
}:

buildPythonPackage rec {
  pname = "django-types";
  version = "0.18.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uOIzTIEIZNer8RzTzbHaOyAVtn5/EnAAfjN3f/G9hlQ=";
  };

  nativeBuildInputs = [ poetry-core ];

  meta = with lib; {
    description = "Type stubs for Django";
    homepage = "https://pypi.org/project/django-types";
    license = licenses.mit;
    maintainers = with maintainers; [ thubrecht ];
  };
}
