{
  lib,
  buildPythonPackage,
  fetchPypi,
  msrest,
  msrestazure,
  azure-common,
}:

buildPythonPackage rec {
  version = "0.61.1";
  format = "setuptools";
  pname = "azure-graphrbac";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-U+mK4sp8GbNJ6em7G2qCSuro3Py+FxkNIP5pwPGFsuI=";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Graph RBAC Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
