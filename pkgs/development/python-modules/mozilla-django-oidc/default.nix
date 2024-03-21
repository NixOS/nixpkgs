{ lib
, buildPythonPackage
, fetchPypi
, isPy27

# buildtime
, setuptools

# runtime
, django
, josepy
, requests
, cryptography
}:

buildPythonPackage rec {
  pname = "mozilla-django-oidc";
  version = "2.0.0";
  format = "pyproject";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qLLyfGnBItL02AHDdZdh0z3r8Grp2ruriu2CiHu6O7g";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    django
    josepy
    requests
    cryptography
  ];

  meta = with lib; {
    description = "A django OpenID Connect library";
    homepage = "https://github.com/mozilla/mozilla-django-oidc";
    license = licenses.mpl20;
    platforms = platforms.linux;
  };
}
