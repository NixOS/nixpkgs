{ lib
, buildPythonPackage
, fetchPypi
, azure-mgmt-common
, python
, isPy3k
}:

buildPythonPackage rec {
  version = "9.0.0";
  pname = "azure-mgmt-network";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "12bsdbh37xiz42hvrp8ghszyqkiali3pk50x44f3aip12pgx6kix";
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
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ olcai mwilsoninsight ];
  };
}
