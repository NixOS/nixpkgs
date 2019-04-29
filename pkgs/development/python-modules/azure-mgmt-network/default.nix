{ lib
, buildPythonPackage
, fetchPypi
, azure-mgmt-common
, python
, isPy3k
}:

buildPythonPackage rec {
  version = "2.6.0";
  pname = "azure-mgmt-network";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0166646703389374736cbe045ffb874e08796407ea0b1b5d441143b054a47e09";
  };

  postInstall = if isPy3k then "" else ''
    echo "__import__('pkg_resources').declare_namespace(__name__)" >> "$out/lib/${python.libPrefix}"/site-packages/azure/__init__.py
    echo "__import__('pkg_resources').declare_namespace(__name__)" >> "$out/lib/${python.libPrefix}"/site-packages/azure/mgmt/__init__.py
  '';

  propagatedBuildInputs = [
    azure-mgmt-common
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "Microsoft Azure SDK for Python";
    homepage = https://docs.microsoft.com/en-us/python/api/overview/azure/network?view=azure-python;
    license = licenses.mit;
    maintainers = with maintainers; [ olcai mwilsoninsight ];
  };
}
