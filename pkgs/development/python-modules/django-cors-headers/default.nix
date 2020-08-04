{ lib,
  fetchPypi,
  django,
  buildPythonPackage
}:

buildPythonPackage rec {
  pname = "django-cors-headers";
  version = "3.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "73d654950b5f5e7e4f67c05183d2169d4f7518ceb87734eb0d68f9e43be59f1c";
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
