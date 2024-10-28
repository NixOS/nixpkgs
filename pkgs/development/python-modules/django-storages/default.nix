{
  lib,
  azure-storage-blob,
  boto3,
  buildPythonPackage,
  cryptography,
  django,
  dropbox,
  fetchFromGitHub,
  google-cloud-storage,
  libcloud,
  moto,
  paramiko,
  pytestCheckHook,
  pythonOlder,
  rsa,
  setuptools,
  fetchpatch,
}:

buildPythonPackage rec {
  pname = "django-storages";
  version = "1.14.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jschneier";
    repo = "django-storages";
    rev = "refs/tags/${version}";
    hash = "sha256-nlM/XPot3auLzNsnHCVtog2WmiaibDRgbPOw9A5F9QI=";
  };

  patches = [
    # Add Moto 5 support
    # https://github.com/jschneier/django-storages/pull/1464
    (fetchpatch {
      url = "https://github.com/jschneier/django-storages/commit/e1aedcf2d137f164101d31f2f430f1594eedd78c.patch";
      hash = "sha256-jSb/uJ0RXvPsXl+WUAzAgDvJl9Y3ad2F30X1SbsCc04=";
      name = "add_moto_5_support.patch";
    })
  ];

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ django ];

  optional-dependencies = {
    azure = [ azure-storage-blob ];
    boto3 = [ boto3 ];
    dropbox = [ dropbox ];
    google = [ google-cloud-storage ];
    libcloud = [ libcloud ];
    s3 = [ boto3 ];
    sftp = [ paramiko ];
  };

  nativeCheckInputs = [
    cryptography
    moto
    pytestCheckHook
    rsa
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "storages" ];

  env.DJANGO_SETTINGS_MODULE = "tests.settings";

  disabledTests = [
    # AttributeError: 'str' object has no attribute 'universe_domain'
    # https://github.com/jschneier/django-storages/issues/1463
    "test_storage_save_gzip"
  ];

  meta = with lib; {
    description = "Collection of custom storage backends for Django";
    changelog = "https://github.com/jschneier/django-storages/blob/${version}/CHANGELOG.rst";
    downloadPage = "https://github.com/jschneier/django-storages/";
    homepage = "https://django-storages.readthedocs.io";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmai ];
  };
}
