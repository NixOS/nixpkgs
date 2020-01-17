{ lib, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "denonavr";
  version = "0.7.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15f2bln3j3z2abanzhi2xdizsvcpirba0lnfwh1m3z2k1483y3vs";
  };

  propagatedBuildInputs = [ requests ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/scarface-4711/denonavr";
    description = "Automation Library for Denon AVR receivers.";
    license = licenses.mit;
    maintainers = with maintainers; [ colemickens ];
  };
}
