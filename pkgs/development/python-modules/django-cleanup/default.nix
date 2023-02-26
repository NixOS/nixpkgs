{ lib, buildPythonPackage, fetchPypi, django
}:

buildPythonPackage rec {
  pname = "django-cleanup";
  version = "7.0.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-KKlp+InGYeug2UOJeGk5gPCUgsl5g70I7lKVXa6NceQ=";
  };

  nativeCheckInputs = [ django ];

  meta = with lib; {
    description = "Automatically deletes old file for FileField and ImageField. It also deletes files on models instance deletion";
    homepage = "https://github.com/un1t/django-cleanup";
    license = licenses.mit;
    maintainers = with maintainers; [ mmai ];
  };
}
