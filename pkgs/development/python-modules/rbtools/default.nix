{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "rbtools-0.4.1";
  namePrefix = "";

  src = fetchurl {
    url = "http://downloads.reviewboard.org/releases/RBTools/0.4/RBTools-0.4.1.tar.gz";
    sha256 = "1v0r7rfzrasj56s53mib51wl056g7ykh2y1c6dwv12r6hzqsycgv";
  };

  propagatedBuildInputs = [ pythonPackages.setuptools ];
}
