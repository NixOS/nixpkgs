{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, Mako, packaging, pysocks, pygments, ROPGadget
, capstone, paramiko, pip, psutil
, pyelftools, pyserial, dateutil
, requests, tox, unicorn, intervaltree, fetchpatch }:

buildPythonPackage rec {
  version = "3.12.0";
  pname = "pwntools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09a7yhsyqxb4xf2r6mbn3p5zx1wp89lxq7lj34y4zbin6ns5929s";
  };

  propagatedBuildInputs = [ Mako packaging pysocks pygments ROPGadget capstone paramiko pip psutil pyelftools pyserial dateutil requests tox unicorn intervaltree ];

  disabled = isPy3k;
  doCheck = false; # no setuptools tests for the package

  # Can be removed when 3.13.0 is released
  patches = [
    (fetchpatch {
      url = "https://github.com/Gallopsled/pwntools/commit/9859f54a21404174dd17efee02f91521a2dd09c5.patch";
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
