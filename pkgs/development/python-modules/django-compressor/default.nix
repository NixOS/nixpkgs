{ lib
, buildPythonPackage
, fetchPypi
, rcssmin
, rjsmin
, django-appconf
, beautifulsoup4
, brotli
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "django-compressor";
  version = "4.4";
  format = "setuptools";

  src = fetchPypi {
    pname = "django_compressor";
    inherit version;
    hash = "sha256-GwrMnPup9pvDjnxB2psNcKILyVWHtkP/75YJz0YGT2c=";
  };

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

  DJANGO_SETTINGS_MODULE = "compressor.test_settings";

  meta = with lib; {
    description = "Compresses linked and inline JavaScript or CSS into single cached files";
    homepage = "https://django-compressor.readthedocs.org/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ desiderius ];
  };
}
