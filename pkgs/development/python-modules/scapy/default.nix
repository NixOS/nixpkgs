{ stdenv, fetchurl, buildPythonPackage, isPy3k, isPyPy }:

buildPythonPackage rec {
  name = "scapy-2.2.0";

  disabled = isPy3k || isPyPy;

  src = fetchurl {
    url = "http://www.secdev.org/projects/scapy/files/${name}.tar.gz";
    sha256 = "1bqmp0xglkndrqgmybpwmzkv462mir8qlkfwsxwbvvzh9li3ndn5";
  };

  meta = with stdenv.lib; {
    description = "Powerful interactive network packet manipulation program";
    homepage = http://www.secdev.org/projects/scapy/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bjornfor ];
  };
}
