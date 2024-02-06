{ lib
, buildPythonPackage
, fetchPypi
, azure-mgmt-nspkg
}:

buildPythonPackage rec {
  pname = "azure-mgmt-datalake-nspkg";
  version = "3.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "deb192ba422f8b3ec272ce4e88736796f216f28ea5b03f28331d784b7a3f4880";
  };

  propagatedBuildInputs = [
    azure-mgmt-nspkg
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Data Lake Management namespace package";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
