{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, Mako, packaging, pysocks, pygments, ROPGadget
, capstone, paramiko, pip, psutil
, pyelftools, pypandoc, pyserial, dateutil
, requests, tox, pandoc, unicorn, intervaltree }:

buildPythonPackage rec {
  version = "3.11.0";
  pname = "pwntools";
  name = pname + "-" + version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "609b3f0ba47c975f4dbedd3da2af4c5ca1b3a2aa13fb99240531b6a68edb87be";
  };

  propagatedBuildInputs = [ Mako packaging pysocks pygments ROPGadget capstone paramiko pip psutil pyelftools pypandoc pyserial dateutil requests tox pandoc unicorn intervaltree ];

  disabled = isPy3k;
  doCheck = false; # no setuptools tests for the package

  meta = with stdenv.lib; {
    homepage = "http://pwntools.com";
    description = "CTF framework and exploit development library";
    license = licenses.mit;
    maintainers = with maintainers; [ bennofs kristoff3r ];
  };
}
