{ buildPythonPackage, fetchFromGitHub, python, lib, django }:

buildPythonPackage rec {
  pname = "django-widget-tweaks";
  version = "1.4.8";

  src = fetchFromGitHub { # package from Pypi missing runtests.py
    owner = "jazzband";
    repo = pname;
    rev = version;
    sha256 = "00w1ja56dc7cyw7a3mph69ax6mkch1lsh4p98ijdhzfpjdy36rbg";
  };

  checkPhase = "${python.interpreter} runtests.py";
  propagatedBuildInputs = [ django ];

  meta = with lib; {
      description = "Tweak the form field rendering in templates, not in python-level form definitions.";
      homepage = "https://github.com/jazzband/django-widget-tweaks";
      license = licenses.mit;
      maintainers = with maintainers; [
          maxxk
      ];
  };
}
