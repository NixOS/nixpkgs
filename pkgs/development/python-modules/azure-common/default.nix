{ buildAzurePythonPackage
, fetchPypi
, lib
, isPy3k
, isPyPy
, python
, azure-nspkg
}:

buildAzurePythonPackage rec {
  version = "1.1.21";
  pname = "azure-common";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "25d696d2affbf5fe9b13aebe66271fce545e673e7e1eeaaec2d73599ba639d63";
  };

  propagatedBuildInputs = lib.optionals (!isPy3k) [ azure-nspkg ];


  checkPhase = "python -c 'import azure.common; print(azure.common.__version__)'";

  meta = with lib; {
    description = "This is the Microsoft Azure common code";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/master/sdk/core/azure-common";
    license = licenses.mit;
    maintainers = with maintainers; [ olcai mwilsoninsight jonringer ];
  };
}
