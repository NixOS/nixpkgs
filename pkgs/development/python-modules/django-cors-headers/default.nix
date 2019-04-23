{ lib,
  fetchPypi,
  django,
  buildPythonPackage
}:

buildPythonPackage rec {
  pname = "django-cors-headers";
  version = "2.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02irmhj61mhz3kaw9md4rqpavzkcvkhfk5lhgvss39yras5sxbm8";
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
