{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, Mako, packaging, pysocks, pygments, ROPGadget
, capstone, paramiko, pip, psutil
, pyelftools, pyserial, dateutil
, requests, tox, unicorn, intervaltree, fetchpatch }:

buildPythonPackage rec {
  version = "4.0.0b0";
  pname = "pwntools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "11f7x7rjad1nawn3r524lzxgz3nk89c6s3xycrscn3n86hh0zgid";
  };

  propagatedBuildInputs = [ Mako packaging pysocks pygments ROPGadget capstone paramiko pip psutil pyelftools pyserial dateutil requests tox unicorn intervaltree ];

  doCheck = false; # no setuptools tests for the package

  meta = with stdenv.lib; {
    homepage = "http://pwntools.com";
    description = "CTF framework and exploit development library";
    license = licenses.mit;
    maintainers = with maintainers; [ bennofs kristoff3r ];
  };
}
