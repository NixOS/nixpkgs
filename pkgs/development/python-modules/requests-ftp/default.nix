{ stdenv, lib, fetchPypi, python, buildPythonPackage, requests }:

buildPythonPackage rec {
  pname = "requests-ftp";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.gz";
    sha256 = "0yh5v21v36dsjsgv4y9dx4mmz35741l5jf6pbq9w19d8rfsww13m";
  };

  propagatedBuildInputs = [ requests ];

  meta = {
    description = "FTP Transport adapter for Requests";
    homepage = http://github.com/Lukasa/requests-ftp;
    license = stdenv.lib.licenses.asl20;
  };
}
