{
  lib,
  buildPythonPackage,
  fetchPypi,
  msrestazure,
  azure-common,
  azure-mgmt-core,
  azure-mgmt-nspkg,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-commerce";
  version = "6.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "6f5447395503b2318f451d24f8021ee08db1cac44f1c3337ea690700419626b6";
  };

  propagatedBuildInputs = [
    msrestazure
    azure-common
    azure-mgmt-core
    azure-mgmt-nspkg
  ];

  prePatch = ''
    rm -f azure_bdist_wheel.py tox.ini
    substituteInPlace setup.py \
      --replace "wheel==0.30.0" "wheel"
    sed -i "/azure-namespace-package/c\ " setup.cfg
  '';

  pythonNamespaces = [ "azure.mgmt" ];

  # has no tests
  doCheck = false;
  pythonImportsCheck = [ "azure.mgmt.commerce" ];

  meta = with lib; {
    description = "This is the Microsoft Azure Commerce Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [
      maxwilson
      jonringer
    ];
  };
}
