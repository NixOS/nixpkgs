{ lib
, buildPythonPackage
, fetchPypi
, django
}:

buildPythonPackage rec {
  pname = "pymemoize";
  version = "1.0.3";

  src = fetchPypi {
    inherit version;
    pname = "PyMemoize";
    sha256 = "0yqr60hm700zph6nv8wb6yp2s0i08mahxvw98bvkmw5ijbsviiq7";
  };

  nativeCheckInputs = [ django ];

  # django.core.exceptions.ImproperlyConfigured: Requested settings, but settings are not configured. You must either define the environment variable DJANGO_SETTINGS_MODULE or call settings.configure() before accessing settings
  doCheck = false;

  meta = with lib; {
    description = "Simple Python cache and memoizing module";
    homepage = "https://github.com/mikeboers/PyMemoize";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmai ];
  };
}

