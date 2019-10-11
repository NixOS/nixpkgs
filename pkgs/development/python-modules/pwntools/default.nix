{ stdenv, buildPythonPackage, fetchFromGitHub
, Mako, packaging, pysocks, pygments, ROPGadget
, capstone, paramiko, pip, psutil
, pyelftools, pyserial, dateutil
, requests, sortedcontainers, tox, unicorn
, intervaltree }:


buildPythonPackage rec {
  version = "unstable-2019-10-09";
  pname = "pwntools";

  src = fetchFromGitHub {
    owner = "Gallopsled";
    repo = pname;
    rev = "fb1178418b11c7aabc816331fbc2874231121a25";
    sha256 = "130qar90i0vl3s1yqahf3m31mlsmbgj1lnqhdmncwyzhjzbp0x33";
  };

  propagatedBuildInputs = [
		Mako packaging pysocks pygments ROPGadget capstone paramiko pip psutil pyelftools pyserial dateutil requests sortedcontainers tox unicorn intervaltree
	];

  doCheck = false; # no unit tests for the package

  meta = with stdenv.lib; {
    homepage = "http://pwntools.com";
    description = "CTF framework and exploit development library";
    license = licenses.mit;
    maintainers = with maintainers; [ bennofs kristoff3r pamplemousse ];
  };
}
