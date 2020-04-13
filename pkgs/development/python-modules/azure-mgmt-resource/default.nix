{ pkgs
, buildPythonPackage
, fetchPypi
, python
, azure-mgmt-common
, isPy3k
}:


buildPythonPackage rec {
  version = "9.0.0";
  pname = "azure-mgmt-resource";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "00bmdbr7hdwb3ibr9sfbgbmmr6626qlz19cdi84d87rcisczf4nw";
  };

  postInstall = if isPy3k then "" else ''
    echo "__import__('pkg_resources').declare_namespace(__name__)" >> "$out/lib/${python.libPrefix}"/site-packages/azure/__init__.py
    echo "__import__('pkg_resources').declare_namespace(__name__)" >> "$out/lib/${python.libPrefix}"/site-packages/azure/mgmt/__init__.py
  '';

  propagatedBuildInputs = [ azure-mgmt-common ];

  # has no tests
  doCheck = false;

  meta = with pkgs.lib; {
    description = "Microsoft Azure SDK for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ olcai mwilsoninsight ];
  };
}
