{ lib,
  fetchPypi,
  django,
  buildPythonPackage
}:

buildPythonPackage rec {
  pname = "django-cors-headers";
  version = "3.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "db82b2840f667d47872ae3e4a4e0a0d72fbecb42779b8aa233fa8bb965f7836a";
  };

  propagatedBuildInputs = [ django ];

  # pypi release does not include tests
  doCheck = false;

  meta = with lib; {
    description = "Django app for handling server Cross-Origin Resource Sharing (CORS) headers";
    homepage = "https://github.com/OttoYiu/django-cors-headers";
    license = licenses.mit;
    maintainers = [ maintainers.ivegotasthma ];
  };
}
