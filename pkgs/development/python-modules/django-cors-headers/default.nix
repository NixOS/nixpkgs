{ lib,
  fetchPypi,
  django,
  buildPythonPackage
}:

buildPythonPackage rec {
  pname = "django-cors-headers";
  version = "3.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "96069c4aaacace786a34ee7894ff680780ec2644e4268b31181044410fecd12e";
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
