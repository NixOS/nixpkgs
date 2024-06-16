{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  django-jquery-js,
}:

buildPythonPackage rec {
  pname = "django-formset-js-improved";
  version = "0.5.0.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pretix";
    repo = "django-formset-js";
    rev = "refs/tags/${version}";
    hash = "sha256-bOM24ldXk9WeV0jl6LIJB3BJ5hVWLA1PJTBBnJBoprU=";
  };

  buildInputs = [ django ];

  propagatedBuildInputs = [ django-jquery-js ];

  pythonImportsCheck = [ "djangoformsetjs" ];

  doCheck = false; # no tests

  meta = with lib; {
    description = "A wrapper for a JavaScript formset helper";
    homepage = "https://github.com/pretix/django-formset-js";
    license = licenses.bsd2;
    maintainers = with maintainers; [ hexa ];
  };
}
