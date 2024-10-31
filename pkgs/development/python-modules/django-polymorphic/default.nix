{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  python,
  django,
  dj-database-url,
}:

buildPythonPackage rec {
  pname = "django-polymorphic";
  version = "3.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "django-polymorphic";
    repo = "django-polymorphic";
    rev = "v${version}";
    hash = "sha256-JJY+FoMPSnWuSsNIas2JedGJpdm6RfPE3E1VIjGuXIc=";
  };

  patches = [
    # Spelling of assertQuerySetEqual changed in Django >= 4.2
    (fetchpatch {
      url = "https://github.com/jazzband/django-polymorphic/commit/63d291f8771847e716a37652f239e3966a3360e1.patch";
      hash = "sha256-rvvD9zfjm8bgH1460BA5K44Oobzv1FRAYq9Rgg291B8=";
    })
  ];

  propagatedBuildInputs = [ django ];

  nativeCheckInputs = [ dj-database-url ];

  # Tests fail for Django >= 5.1.0
  doCheck = lib.versionOlder django.version "5.1.0";

  checkPhase = ''
    ${python.interpreter} runtests.py
  '';

  pythonImportsCheck = [ "polymorphic" ];

  meta = with lib; {
    homepage = "https://github.com/django-polymorphic/django-polymorphic";
    description = "Improved Django model inheritance with automatic downcasting";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
