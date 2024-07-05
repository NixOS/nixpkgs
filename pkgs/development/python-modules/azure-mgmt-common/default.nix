{
  pkgs,
  buildPythonPackage,
  fetchPypi,
  python,
  azure-common,
  azure-mgmt-nspkg,
  requests,
  msrestazure,
  isPy3k,
}:

buildPythonPackage rec {
  version = "0.20.0";
  format = "setuptools";
  pname = "azure-mgmt-common";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "c63812c13d9f36615c07f874bc602b733bb516f1ed62ab73189b8f71c6bfbfe6";
  };

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-nspkg
    requests
    msrestazure
  ];

  postInstall = pkgs.lib.optionalString (!isPy3k) ''
    echo "__import__('pkg_resources').declare_namespace(__name__)" >> "$out/${python.sitePackages}"/azure/mgmt/__init__.py
    echo "__import__('pkg_resources').declare_namespace(__name__)" >> "$out/${python.sitePackages}"/azure/__init__.py
  '';

  doCheck = false;

  meta = with pkgs.lib; {
    description = "This is the Microsoft Azure Resource Management common code";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [
      olcai
      maxwilson
    ];
  };
}
