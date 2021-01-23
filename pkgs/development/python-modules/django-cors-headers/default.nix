{ lib,
  fetchPypi,
  django,
  buildPythonPackage
}:

buildPythonPackage rec {
  pname = "django-cors-headers";
  version = "3.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5665fc1b1aabf1b678885cf6f8f8bd7da36ef0a978375e767d491b48d3055d8f";
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
