{ lib, buildPythonPackage, fetchPypi
, django

, azure-storage-blob
, boto3
, dropbox
, google-cloud-storage
, libcloud
, paramiko
}:

buildPythonPackage rec {
  pname = "django-storages";
  version = "1.12.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a475edb2f0f04c4f7e548919a751ecd50117270833956ed5bd585c0575d2a5e7";
  };

  propagatedBuildInputs = [ django ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=tests.settings
    # timezone issues https://github.com/jschneier/django-storages/issues/1171
    substituteInPlace tests/test_sftp.py \
      --replace 'test_accessed_time' 'dont_test_accessed_time' \
      --replace 'test_modified_time' 'dont_test_modified_time'
  '';
  checkInputs = [
    azure-storage-blob
    boto3
    dropbox
    google-cloud-storage
    libcloud
    paramiko
  ];

  pythonImportsCheck = [ "storages" ];

  meta = with lib; {
    description = "Collection of custom storage backends for Django";
    homepage = "https://django-storages.readthedocs.io";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmai ];
  };
}
