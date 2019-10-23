{ pkgs
, buildPythonPackage
, fetchPypi
, python
, azure-mgmt-common
, isPy3k
}:


buildPythonPackage rec {
  version = "2.2.0";
  pname = "azure-mgmt-resource";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "173pxgly95dwblp4nj4l70zb0gasibgcjmcynxwa5282plynhgdw";
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
