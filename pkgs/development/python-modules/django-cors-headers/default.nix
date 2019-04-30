{ lib,
  fetchPypi,
  django,
  buildPythonPackage
}:

buildPythonPackage rec {
  pname = "django-cors-headers";
  version = "2.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fb44f6b9f10de847919305c3f0d38fcfbadfe0dd5cf1c866f37df66ad0dda1bb";
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
