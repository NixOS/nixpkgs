{ lib
, buildPythonPackage
, fetchPypi
, rcssmin
, rjsmin
, django-appconf
, beautifulsoup4
, brotli
, pytestCheckHook
<<<<<<< HEAD
, django-sekizai
, pytest-django
, csscompressor
, calmjs
, jinja2
, python
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "django-compressor";
<<<<<<< HEAD
  version = "4.4";
=======
  version = "4.3.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchPypi {
    pname = "django_compressor";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-GwrMnPup9pvDjnxB2psNcKILyVWHtkP/75YJz0YGT2c=";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    calmjs
    django-appconf
    jinja2
    rcssmin
    rjsmin
  ];

  checkInputs = [
    beautifulsoup4
    brotli
    csscompressor
    django-sekizai
    pytestCheckHook
    pytest-django
  ];

  # Getting error: compressor.exceptions.OfflineGenerationError: You have
  # offline compression enabled but key "..." is missing from offline manifest.
  # You may need to run "python manage.py compress"
  disabledTestPaths = [
    "compressor/tests/test_offline.py"
  ];

  pythonImportsCheck = [ "compressor" ];

=======
    hash = "sha256-aIWMDabMCZzCmgIthsO6iu0RTanXCe7OsNe4GBtfiUI=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "rcssmin == 1.1.0" "rcssmin>=1.1.0" \
      --replace "rjsmin == 1.2.0" "rjsmin>=1.2.0"
  '';

  propagatedBuildInputs = [
    rcssmin
    rjsmin
    django-appconf
  ];

  pythonImportsCheck = [
    "compressor"
  ];

  doCheck = false; # missing package django-sekizai

  nativeCheckInputs = [
    beautifulsoup4
    brotli
    pytestCheckHook
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  DJANGO_SETTINGS_MODULE = "compressor.test_settings";

  meta = with lib; {
    description = "Compresses linked and inline JavaScript or CSS into single cached files";
<<<<<<< HEAD
    homepage = "https://django-compressor.readthedocs.org/";
    changelog = "https://github.com/django-compressor/django-compressor/blob/${version}/docs/changelog.txt";
=======
    homepage = "https://django-compressor.readthedocs.org/en/latest/";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ desiderius ];
  };
}
