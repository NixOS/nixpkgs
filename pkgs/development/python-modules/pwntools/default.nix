{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, Mako, packaging, pysocks, pygments, ROPGadget
, capstone, paramiko, pip, psutil
, pyelftools, pyserial, dateutil
, requests, tox, unicorn, intervaltree, fetchpatch }:

buildPythonPackage rec {
  version = "4.1.1";
  pname = "pwntools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "694ce7a6cfca0ad40eae36c1d2663c44eb953f84785c63daa9752b4dfa7f39d8";
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
