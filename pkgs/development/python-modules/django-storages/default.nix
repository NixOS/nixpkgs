{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, setuptools

# dependencies
, django

# optional-dependencies
, azure-storage-blob
, boto3
, dropbox
, google-cloud-storage
, libcloud
, paramiko

# tests
, cryptography
, moto
, pytestCheckHook
, rsa
}:

buildPythonPackage rec {
  pname = "django-storages";
  version = "1.14";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jschneier";
    repo = "django-storages";
    rev = "refs/tags/${version}";
    hash = "sha256-q+vQm1T5/ueGPfwzuUOmSI/nESchqJc4XizJieBsLWc=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    django
  ];

  passthru.optional-dependencies = {
    azure = [
      azure-storage-blob
    ];
    boto3 = [
      boto3
    ];
    dropbox = [
      dropbox
    ];
    google = [
      google-cloud-storage
    ];
    libcloud = [
      libcloud
    ];
    s3 = [
      boto3
    ];
    sftp = [
      paramiko
    ];
  };

  pythonImportsCheck = [
    "storages"
  ];

  env.DJANGO_SETTINGS_MODULE = "tests.settings";

  nativeCheckInputs = [
    cryptography
    moto
    pytestCheckHook
    rsa
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  meta = with lib; {
    changelog = "https://github.com/jschneier/django-storages/blob/${version}/CHANGELOG.rst";
    description = "Collection of custom storage backends for Django";
    downloadPage = "https://github.com/jschneier/django-storages/";
    homepage = "https://django-storages.readthedocs.io";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmai ];
  };
}
