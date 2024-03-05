{ lib
, azure-storage-blob
, boto3
, buildPythonPackage
, cryptography
, django
, dropbox
, fetchFromGitHub
, google-cloud-storage
, libcloud
, moto
, paramiko
, pytestCheckHook
, pythonOlder
, rsa
, setuptools
}:

buildPythonPackage rec {
  pname = "django-storages";
  version = "1.14";
  pyproject = true;

  disabled = pythonOlder "3.7";

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
    description = "Collection of custom storage backends for Django";
    changelog = "https://github.com/jschneier/django-storages/blob/${version}/CHANGELOG.rst";
    downloadPage = "https://github.com/jschneier/django-storages/";
    homepage = "https://django-storages.readthedocs.io";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmai ];
  };
}
