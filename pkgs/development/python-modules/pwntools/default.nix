{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, Mako, packaging, pysocks, pygments, ROPGadget
, capstone, paramiko, pip, psutil
, pyelftools, pyserial, dateutil
, requests, tox, unicorn, intervaltree, fetchpatch }:

buildPythonPackage rec {
  version = "4.1.0";
  pname = "pwntools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c9axs2kas58ihgn74d12c4xxgvvqybf8f8wvf0k0sxbfh4hddfk";
  };

  propagatedBuildInputs = [ Mako packaging pysocks pygments ROPGadget capstone paramiko pip psutil pyelftools pyserial dateutil requests tox unicorn intervaltree ];

  doCheck = false; # no setuptools tests for the package

  meta = with stdenv.lib; {
    homepage = "http://pwntools.com";
    description = "CTF framework and exploit development library";
    license = licenses.mit;
    maintainers = with maintainers; [ bennofs kristoff3r arturcygan ];
  };
}
