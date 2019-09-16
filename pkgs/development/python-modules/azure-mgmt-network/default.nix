{ lib
, buildPythonPackage
, fetchPypi
, azure-mgmt-common
, python
, isPy3k
}:

buildPythonPackage rec {
  version = "4.0.0";
  pname = "azure-mgmt-network";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0h2lnigmh2arq0ppwjk8h9rqxplj6s7h7qxwyv7wirk0ydx6cfd9";
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
