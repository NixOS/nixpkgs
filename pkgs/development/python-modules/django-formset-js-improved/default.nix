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
    tag = version;
    hash = "sha256-bOM24ldXk9WeV0jl6LIJB3BJ5hVWLA1PJTBBnJBoprU=";
  };

  buildInputs = [ django ];

  propagatedBuildInputs = [ django-jquery-js ];

  pythonImportsCheck = [ "djangoformsetjs" ];

  doCheck = false; # no tests

  meta = {
    description = "Wrapper for a JavaScript formset helper";
    homepage = "https://github.com/pretix/django-formset-js";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
