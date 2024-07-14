{
  pkgs,
  buildPythonPackage,
  fetchPypi,
  azure-nspkg,
}:

buildPythonPackage rec {
  version = "3.0.2";
  format = "setuptools";
  pname = "azure-mgmt-nspkg";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-iyKH9nFSlQWylgBebekVCwdDRMLH0cgFs/BT0IHVjFI=";
  };

  propagatedBuildInputs = [ azure-nspkg ];

  doCheck = false;

  meta = with pkgs.lib; {
    description = "Microsoft Azure SDK for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [
      olcai
      maxwilson
    ];
  };
}
