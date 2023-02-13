{ lib, buildPythonPackage, fetchPypi, django
}:

buildPythonPackage rec {
  pname = "django-cleanup";
  version = "6.0.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "922e06ef8839c92bd3ab37a84db6058b8764f3fe44dbb4487bbca941d288280a";
  };

  nativeCheckInputs = [ django ];

  meta = with lib; {
    description = "Automatically deletes old file for FileField and ImageField. It also deletes files on models instance deletion";
    homepage = "https://github.com/un1t/django-cleanup";
    license = licenses.mit;
    maintainers = with maintainers; [ mmai ];
  };
}
