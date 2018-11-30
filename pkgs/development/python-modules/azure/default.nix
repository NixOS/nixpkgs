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
  version = "0.11.0";
  pname = "azure";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "89c20b2efaaed3c6f56345d55c32a8d4e7d2a16c032d0acb92f8f490c508fe24";
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
