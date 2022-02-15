{ buildPythonPackage, fetchFromGitHub, python, lib, django }:

buildPythonPackage rec {
  pname = "django-widget-tweaks";
  version = "1.4.12";

  src = fetchFromGitHub { # package from Pypi missing runtests.py
    owner = "jazzband";
    repo = pname;
    rev = version;
    sha256 = "1rhn2skx287k6nnkxlwvl9snbia6w6z4c2rqg22hwzbz5w05b24h";
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
