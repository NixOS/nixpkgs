{ stdenv, fetchurl, pkgconfig, cmake, perl }:

with stdenv.lib;
stdenv.mkDerivation rec{

  name = "libtap-${version}";
  version = "1.12.0";

  src = fetchurl {
    url = "https://web-cpan.shlomifish.org/downloads/${name}.tar.bz2";
    sha256 = "1ms1770cx8c6q3lhn1chkzy12vzmjgvlms7cqhd2d3260j2wwv5s";
  };

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ cmake perl ];

  meta = with stdenv.lib; {
    description = "A library to implement a test protocol";
    longDescription = ''
      libtap is a library to implement the Test Anything Protocol for
      C originally created by Nik Clayton. This is a maintenance
      branch by Shlomi Fish.
    '';
    homepage = https://www.shlomifish.org/open-source/projects/libtap/;
    license = licenses.bsd3;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.unix;
  };
}
