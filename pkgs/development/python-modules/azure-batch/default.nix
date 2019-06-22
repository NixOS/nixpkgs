{ lib, buildAzurePythonPackage, fetchPypi, isPy3k
, azure-common
, msrestazure
}:

buildAzurePythonPackage rec {
  version = "7.0.0";
  pname = "azure-batch";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1q8mdjdbz408z2j0y1zxqg9zg8j1v84p0dnh621vq73a2x1g298j";
  };

  propagatedBuildInputs = [
    azure-common
    msrestazure
  ];

  # tests not included in source package
  # github repo contains over 80 other azure namespace packages
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Batch Client Library";
    homepage = https://docs.microsoft.com/en-us/python/api/overview/azure/batch?view=azure-python;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight jonringer ];
  };
}
