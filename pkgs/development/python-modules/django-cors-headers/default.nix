{ lib,
  fetchPypi,
  django,
  buildPythonPackage
}:

buildPythonPackage rec {
  pname = "django-cors-headers";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0g1vqhc36ay518vs67kkf6w76ay27dc73w145bpwgp9fky81r6z6";
  };

  propagatedBuildInputs = [ django ];

  # pypi release does not include tests
  doCheck = false;

  meta = with lib; {
    description = "Django app for handling server Cross-Origin Resource Sharing (CORS) headers";
    homepage = https://github.com/OttoYiu/django-cors-headers;
    license = licenses.mit;
    maintainers = [ maintainers.ivegotasthma ];
  };
}
