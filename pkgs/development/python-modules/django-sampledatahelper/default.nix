{ lib
, buildPythonPackage
, fetchFromGitHub
, versiontools
, django
, sampledata
, nose
, pillow
, six
}:

buildPythonPackage rec {
  pname = "django-sampledatahelper";
  version = "0.5";

  # no tests on PyPI
  src = fetchFromGitHub {
    owner = "kaleidos";
    repo = "django-sampledatahelper";
    rev = "8576f352ec26a3650f4386a6e1285b723f6aec23"; # no tag
    sha256 = "1fx3ql4b9791594zkary19n20x5ra1m1n3pjaya9di1qy64csac4";
  };

  nativeBuildInputs = [ versiontools ];

  propagatedBuildInputs = [ django sampledata ];

  checkInputs = [ nose pillow six ];

  checkPhase = ''
    DJANGO_SETTINGS_MODULE=tests.settings NOSE_EXCLUDE=test_calling_command nosetests -v
  '';

  meta = {
    description = "Helper class for generate sample data for django apps development";
    homepage = "https://github.com/kaleidos/django-sampledatahelper";
    license = lib.licenses.bsd3;
  };
}
