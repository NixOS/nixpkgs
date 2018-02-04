{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, Mako, packaging, pysocks, pygments, ROPGadget
, capstone, paramiko, pip, psutil
, pyelftools, pyserial, dateutil
, requests, tox, unicorn, intervaltree, fetchpatch }:

buildPythonPackage rec {
  version = "3.11.0";
  pname = "pwntools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "609b3f0ba47c975f4dbedd3da2af4c5ca1b3a2aa13fb99240531b6a68edb87be";
  };

  propagatedBuildInputs = [ Mako packaging pysocks pygments ROPGadget capstone paramiko pip psutil pyelftools pyserial dateutil requests tox unicorn intervaltree ];

  disabled = isPy3k;
  doCheck = false; # no setuptools tests for the package

  # Can be removed when 3.12.0 is released
  patches = [
    (fetchpatch {
      url = "https://github.com/Gallopsled/pwntools/pull/1098.patch";
      sha256 = "0p0h87npn1mwsd8ciab7lg74bk3ahlk5r0mjbvx4jhihl2gjc3z2";
    })
  ];


  meta = with stdenv.lib; {
    homepage = "http://pwntools.com";
    description = "CTF framework and exploit development library";
    license = licenses.mit;
    maintainers = with maintainers; [ bennofs kristoff3r ];
  };
}
