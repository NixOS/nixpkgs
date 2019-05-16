{ stdenv
, buildPythonPackage
, fetchPypi
, isPy27
}:

buildPythonPackage rec {
  pname = "python-wifi";
  version = "0.6.1";
  disabled = !isPy27;

  src = fetchPypi {
    inherit pname version;
    extension = "tar.bz2";
    sha256 = "149c3dznb63d82143cz5hqdim0mqjysz6p3yk0zv271vq3xnmzvv";
  };

  meta = with stdenv.lib; {
    inherit version;
    description = "Read & write wireless card capabilities using the Linux Wireless Extensions";
    homepage = http://pythonwifi.tuxfamily.org/;
    # From the README: "pythonwifi is licensed under LGPLv2+, however, the
    # examples (e.g. iwconfig.py and iwlist.py) are licensed under GPLv2+."
    license = with licenses; [ lgpl2Plus gpl2Plus ];
  };

}
