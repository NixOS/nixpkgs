{ lib
, buildPythonPackage
, fetchPypi
, msrest
, msrestazure
, azure-common
, azure-mgmt-nspkg
, isPy3k
}:

buildPythonPackage rec {
  pname = "azure-mgmt-media";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "5d0c6b3a0f882dde8ae3d42467f03ea6c4e3f62613936087d54c67e6f504939b";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
  ] ++ lib.optionals (!isPy3k) [
    azure-mgmt-nspkg
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Media Services Client Library";
    homepage = https://docs.microsoft.com/en-us/python/api/overview/azure/media-services?view=azure-python;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
