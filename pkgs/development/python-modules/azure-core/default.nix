{ buildPythonPackage
, fetchPypi
, lib

# Python dependencies
, pythonPackages
}:

buildPythonPackage rec {
  pname = "azure-core";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "00jm43gw89n446zdm18qziwd85lsx1gandxpmw62dc1bdnsfakxl";
  };

  propagatedBuildInputs = with pythonPackages; [
    requests
  ];

  doCheck = false;

  meta = with lib; {
    description = "Microsoft Azure Core Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [
      kamadorueda
    ];
  };
}
