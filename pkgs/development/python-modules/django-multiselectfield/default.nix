{ lib
, buildPythonPackage
, fetchFromGitHub
, django
}:

buildPythonPackage rec {
  pname = "django-multiselectfield";
  version = "0.1.12";

  src = fetchFromGitHub {
     owner = "goinnn";
     repo = "django-multiselectfield";
     rev = "v0.1.12";
     sha256 = "1bjydd4zh6wzxmv4drx5fslwcv51qa57l3lc2216fni89islnj2m";
  };

  propagatedBuildInputs = [ django ];

  # No tests
  doCheck = false;

  meta = {
    description = "django-multiselectfield";
    homepage = "https://github.com/goinnn/django-multiselectfield";
    license = lib.licenses.lgpl3;
  };
}
