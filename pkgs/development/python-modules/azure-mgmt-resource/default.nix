{ pkgs
, buildPythonPackage
, fetchPypi
, python
, azure-mgmt-common
, isPy3k
}:


buildPythonPackage rec {
  version = "4.0.0";
  pname = "azure-mgmt-resource";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0gy89bi89ikg5hps8rvnq28r33lixci3sk2m86jvziv9fh9rz41b";
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
    homepage = https://docs.microsoft.com/en-us/python/api/overview/azure/resources?view=azure-python;
    license = licenses.mit;
    maintainers = with maintainers; [ olcai mwilsoninsight ];
  };
}
