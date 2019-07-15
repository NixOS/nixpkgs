{ lib, fetchPypi, buildPythonPackage, flake8 }:

buildPythonPackage rec {
  pname = "flake8-quotes";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f10q2580bzxmr0lic42q32qbyf3aq42di91wyl04hrd8xmszj8h";
  };

  buildInputs = [ flake8 ];

  doCheck = false;

  meta = {
    homepage = http://github.com/zheller/flake8-quotes/;
    description = "flake8 lint for quotes";
    maintainers = with lib.maintainers; [ mog ];
    license = lib.licenses.mit;
  };
}
