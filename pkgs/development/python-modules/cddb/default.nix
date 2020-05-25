{ stdenv
, buildPythonPackage
, pkgs
, isPy3k
}:

buildPythonPackage rec {
  pname = "CDDB";
  version = "1.4";
  disabled = isPy3k;

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ pkgs.darwin.apple_sdk.frameworks.IOKit ];

  src = pkgs.fetchurl {
    url = "http://cddb-py.sourceforge.net/${pname}-${version}.tar.gz";
    sha256 = "098xhd575ibvdx7i3dny3lwi851yxhjg2hn5jbbgrwj833rg5l5w";
  };

  meta = with stdenv.lib; {
    homepage = "http://cddb-py.sourceforge.net/";
    description = "CDDB and FreeDB audio CD track info access";
    license = licenses.gpl2Plus;
  };

}
