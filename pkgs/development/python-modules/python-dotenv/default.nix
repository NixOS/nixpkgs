{ lib, buildPythonPackage, fetchPypi, click, ipython }:

buildPythonPackage rec {
  pname = "python-dotenv";
  version = "0.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1q4sp6ppjiqlsz3h43q9iya4n3qkhx6ng16bcbacfxdyrp9xvcf9";
  };

  checkInputs = [ click ipython ];

  meta = with lib; {
    description = "Add .env support to your django/flask apps in development and deployments";
    homepage = https://github.com/theskumar/python-dotenv;
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ earvstedt ];
  };
}
