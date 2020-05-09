{ lib,
  fetchPypi,
  django,
  buildPythonPackage
}:

buildPythonPackage rec {
  pname = "django-cors-headers";
  version = "3.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a5960addecc04527ab26617e51b8ed42f0adab4594b24bb0f3c33e2bd3857c3f";
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
