{ lib,
  fetchPypi,
  django,
  buildPythonPackage
}:

buildPythonPackage rec {
  pname = "django-cors-headers";
  version = "3.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0b11nkcviwv5dqnlmv63bgzciczb51wairm8b6wr6sda4p7y5wzb";
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
