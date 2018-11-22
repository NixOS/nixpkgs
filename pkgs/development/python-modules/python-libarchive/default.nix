{ stdenv
, buildPythonPackage
, fetchurl
, isPy3k
, pkgs
}:

buildPythonPackage rec {
  version = "3.1.2-1";
  pname = "libarchive";
  disabled = isPy3k;

  src = fetchurl {
    url = "http://python-libarchive.googlecode.com/files/python-libarchive-${version}.tar.gz";
    sha256 = "0j4ibc4mvq64ljya9max8832jafi04jciff9ia9qy0xhhlwkcx8x";
  };

  propagatedBuildInputs = [ pkgs.libarchive.lib ];

  meta = with stdenv.lib; {
    description = "Multi-format archive and compression library";
    homepage = https://libarchive.org/;
    license = licenses.bsd0;
    broken = true;
  };

}
