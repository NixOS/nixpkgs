{ pkgs
, buildPythonPackage
, fetchPypi
, dateutil
, futures
, pyopenssl
, requests
, pythonOlder
, isPy3k
}:

buildPythonPackage rec {
  version = "4.0.0";
  pname = "azure";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "7d6afa332fccffe1a9390bcfac5122317eec657c6029f144d794603a81cd0e50";
  };

  propagatedBuildInputs = [ dateutil pyopenssl requests ]
                            ++ pkgs.lib.optionals (!isPy3k) [ futures ];

  # depends on futures for python 3 (not necissary)
  patchPhase = if (!isPy3k) then "" else ''
    sed -i -e "s/'futures'//" setup.py
  '';

  # tests are not packaged in pypi release
  doCheck = false;

  meta = with pkgs.lib; {
    description = "Microsoft Azure SDK for Python";
    homepage = "https://azure.microsoft.com/en-us/develop/python/";
    license = licenses.asl20;
    maintainers = with maintainers; [ olcai ];
  };
}
