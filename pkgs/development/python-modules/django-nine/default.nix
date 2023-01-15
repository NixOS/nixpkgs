{ lib
# Dependencies
, django
# Build
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "django-nine";
  version = "0.2.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ME4Pg86lo1NZN1/JGdAPmRe2VcHTiCRMv8c2P1lIkXc=";
  };

  propagatedBuildInputs = [ django ];

  # No tests
  doCheck = false;

  meta = with lib; {
    description = "version checking library for Django.";
    homepage = "https://pypi.org/project/django-nine/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ sebastiaan ];
  };
}