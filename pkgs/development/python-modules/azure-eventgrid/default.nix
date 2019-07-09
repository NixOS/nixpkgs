{ lib, buildAzurePythonPackage, fetchPypi
, azure-common
, msrest
, msrestazure
}:

buildAzurePythonPackage rec {
  version = "1.3.0";
  pname = "azure-eventgrid";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0vn8d1hq1ln9d5k0bssahwrxgipdljvg35cgrrlyrbjrxbv4nb68";
  };

  propagatedBuildInputs = [
    azure-common
    msrest
    msrestazure
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "A fully-managed intelligent event routing service that allows for uniform event consumption using a publish-subscribe model";
    homepage = "https://docs.microsoft.com/en-us/python/api/overview/azure/event-grid";
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight jonringer ];
  };
}
