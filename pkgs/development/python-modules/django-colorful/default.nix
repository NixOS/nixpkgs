{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
}:

buildPythonPackage rec {
  pname = "django-colorful";
  version = "1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/SRvL7KX7QdNxDSZZtM6HILQMIt/sNbvbi52uQzv/7c=";
  };

  # Tests aren't run
  doCheck = false;

  # Requires Django >= 1.8
  buildInputs = [ django ];

  meta = with lib; {
    description = "Django extension that provides database and form color fields";
    homepage = "https://github.com/charettes/django-colorful";
    license = licenses.mit;
  };
}
