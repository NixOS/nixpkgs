{ lib, buildPythonPackage, fetchPypi, click, ipython }:

buildPythonPackage rec {
  pname = "python-dotenv";
  version = "0.10.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6640acd76e6cab84648e4fec16c9d19de6700971f9d91d045e7120622167bfda";
  };

  checkInputs = [ click ipython ];

  meta = with lib; {
    description = "Add .env support to your django/flask apps in development and deployments";
    homepage = https://github.com/theskumar/python-dotenv;
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ earvstedt ];
  };
}
