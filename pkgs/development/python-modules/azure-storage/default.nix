{ pkgs
, buildPythonPackage
, fetchPypi
, azure-common
, cryptography
, futures ? null
, python-dateutil
, requests
, isPy3k
}:

buildPythonPackage rec {
  version = "0.36.0";
  pname = "azure-storage";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pyasfxkin6j8j00qmky7d9cvpxgis4fi9bscgclj6yrpvf14qpv";
  };

  propagatedBuildInputs = [ azure-common cryptography python-dateutil requests ]
                            ++ pkgs.lib.optionals (!isPy3k) [ futures ];

  postPatch = ''
    rm azure_bdist_wheel.py
    substituteInPlace setup.cfg \
      --replace "azure-namespace-package = azure-nspkg" ""
  '';

  meta = with pkgs.lib; {
    description = "Microsoft Azure SDK for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ olcai ];
  };
}
