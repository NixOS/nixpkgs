{ lib
, buildPythonPackage
, fetchFromGitHub
, azure-common
, requests
}:

buildPythonPackage {
  version = "0.20.7";
  pname = "azure-servicemanagement-legacy";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-sdk-for-python";
    rev = "ab01fc1f23462f130c69f46505524b88101023dc";
    sha256 = "0w2bm9hkwy1m94l8r2klnpqn4192y8bir3z8bymxgfx9y0b1mn2q";
  };

  preBuild = ''
    cd ./azure-servicemanagement-legacy
  '';

  propagatedBuildInputs = [
    azure-common
    requests
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Service Management Legacy Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ olcai mwilsoninsight ];
  };
}
