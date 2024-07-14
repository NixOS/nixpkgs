{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-common,
  azure-storage-common,
  isPy3k,
  futures ? null,
}:

buildPythonPackage rec {
  pname = "azure-storage-file";
  version = "2.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NVm5x6sTRQxm6oM+uCwoIzvuJPG9jKGap9J/jCPVvFM=";
  };

  propagatedBuildInputs = [
    azure-common
    azure-storage-common
  ] ++ lib.optional (!isPy3k) futures;

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "Client library for Microsoft Azure Storage services containing the file service APIs";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
