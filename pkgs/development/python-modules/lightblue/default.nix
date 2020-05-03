{ stdenv
, buildPythonPackage
, fetchurl
, pkgs
, isPy3k
}:

buildPythonPackage rec {
  pname = "lightblue";
  version = "0.4";
  disabled = isPy3k; # build fails, 2018-04-11

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "016h1mlhpqxjj25lcvl4fqc19k8ifmsv6df7rhr12fyfcrp5i14d";
  };

  buildInputs = [ pkgs.bluez pkgs.openobex ];

  meta = with stdenv.lib; {
    homepage = "http://lightblue.sourceforge.net";
    description = "Cross-platform Bluetooth API for Python";
    maintainers = with maintainers; [ leenaars ];
    license = licenses.gpl3;
  };

}
