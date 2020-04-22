{ pkgs
, buildPythonPackage
, fetchPypi
, dateutil
, futures
, pyopenssl
, requests
, isPy3k
}:

buildPythonPackage rec {
  version = "5.0.0";
  pname = "azure";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "f56d22acaba0ce74b821fd3d012d18854f9d0b3662d5a3a9240b1bd587c96b23";
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
    broken = true; # this should propagate over 70 azure packages, many of which are not added yet
  };
}
