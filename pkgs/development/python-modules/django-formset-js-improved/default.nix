{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  django,
  django-jquery-js,
}:

buildPythonPackage rec {
  pname = "django-formset-js-improved";
  version = "0.5.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretix";
    repo = "django-formset-js";
    tag = version;
    hash = "sha256-bOM24ldXk9WeV0jl6LIJB3BJ5hVWLA1PJTBBnJBoprU=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/pretix/django-formset-js/commit/7d8a33190d58ff9d75270264342eba82672d054e.patch";
      hash = "sha256-eBRP0eqMnH7UM9cToR+diejO6dMDDVt2bbUHLDcaWjk=";
    })
  ];

  build-system = [ setuptools ];

  buildInputs = [ django ];

  dependencies = [ django-jquery-js ];

  pythonImportsCheck = [ "djangoformsetjs" ];

  doCheck = false; # no tests

  meta = with lib; {
    description = "Wrapper for a JavaScript formset helper";
    homepage = "https://github.com/pretix/django-formset-js";
    license = licenses.bsd2;
    maintainers = with maintainers; [ hexa ];
  };
}
