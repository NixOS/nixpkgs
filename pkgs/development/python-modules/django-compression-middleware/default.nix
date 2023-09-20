{ lib
, fetchPypi
, buildPythonPackage
, django
, zstandard
, brotli
}:

buildPythonPackage rec {
  pname = "django-compression-middleware";
  version = "0.5.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DfUPEtd0ZZq8i7yI5MeU8nhajxHzC1uyZ8MUuF2UG3M=";
  };

  propagatedBuildInputs = [
    django
    zstandard
    brotli
  ];

  meta = with lib; {
    description = "Django middleware to compress responses using several algorithms";
    homepage = "https://github.com/friedelwolff/django-compression-middleware";
    changelog = "https://github.com/friedelwolff/django-compression-middleware/releases/tag/v${version}";
    license = licenses.mpl20;
    maintainers = with maintainers; [ e1mo ];
  };
}
