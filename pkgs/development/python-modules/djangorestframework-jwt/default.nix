{ lib
, fetchPypi
, django
, pyjwt
, djangorestframework
, buildPythonPackage
}:

let

  pyjwt' = pyjwt.overridePythonAttrs (oldAttrs: rec {
    version = "1.7.1";
    src = oldAttrs.src.override {
      inherit version;
      sha256 = "jVmpdvt3Pz5qOchWNjV8Tw4kJwc5TK2t2YFPXLqiDpY=";
    };
  });

in

buildPythonPackage rec {
  pname = "djangorestframework-jwt";
  version = "1.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19rng6v1sw14mbjp5cplnrgxjnhlj8faalfw02iihi9s5w1k7zjy";
  };

  propagatedBuildInputs = [ pyjwt' django djangorestframework ];

  # ./runtests.py fails because the project must be tested against a django
  # installation, there are missing database tables for User, that don't exist.
  doCheck = false;

  meta = with lib; {
    description = "JSON Web Token Authentication support for Django REST Framework";
    homepage = "https://github.com/GetBlimp/django-rest-framework-jwt";
    license = licenses.mit;
    maintainers = [ maintainers.ivegotasthma ];
  };
}
