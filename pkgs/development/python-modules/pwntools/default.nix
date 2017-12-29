{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, Mako, packaging, pysocks, pygments, ROPGadget
, capstone, paramiko, pip, psutil
, pyelftools, pypandoc, pyserial, dateutil
, requests, tox, pandoc, unicorn, intervaltree }:

buildPythonPackage rec {
  version = "3.10.0";
  pname = "pwntools";
  name = "pwntools-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1l8hb30mwxqd1y7r5ihd7kzmjm2mz6m5aiphd3hwzmxkmxbxj8zk";
  };

  propagatedBuildInputs = [ Mako packaging pysocks pygments ROPGadget capstone paramiko pip psutil pyelftools pypandoc pyserial dateutil requests tox pandoc unicorn intervaltree ];

  disabled = isPy3k;

  meta = with stdenv.lib; {
    homepage = "http://pwntools.com";
    description = "CTF framework and exploit development library";
    license = licenses.mit;
    maintainers = with maintainers; [ bennofs kristoff3r ];
  };
}
