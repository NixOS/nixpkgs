{
  lib,
  azure-storage-blob,
  boto3,
  buildPythonPackage,
  cryptography,
  django,
  dropbox,
  fetchFromGitHub,
  fetchpatch,
  google-cloud-storage,
  libcloud,
  moto,
  paramiko,
  pynacl,
  pytestCheckHook,
  pythonOlder,
  rsa,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-storages";
  version = "1.14.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jschneier";
    repo = "django-storages";
    tag = version;
    hash = "sha256-br7JGPf5EAAl0Qg7b+XaksxNPCTJsSS8HLgvA0wZmeI=";
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

  build-system = [ setuptools ];

  dependencies = [ django ];

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
  ]
  ++ lib.concatAttrValues optional-dependencies;

  checkInputs = [ pynacl ];

  pythonImportsCheck = [ "storages" ];

  env.DJANGO_SETTINGS_MODULE = "tests.settings";

  meta = {
    description = "Collection of custom storage backends for Django";
    changelog = "https://github.com/jschneier/django-storages/blob/${version}/CHANGELOG.rst";
    downloadPage = "https://github.com/jschneier/django-storages/";
    homepage = "https://django-storages.readthedocs.io";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mmai ];
  };
}
