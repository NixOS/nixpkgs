{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libffcall-${version}";
  version = "2.0";

  src = fetchurl {
    url = "mirror://gnu/libffcall/libffcall-${version}.tar.gz";
    sha256 = "0v0rh3vawb8z5q40fs3kr2f9zp06n2fq4rr2ww4562nr96sd5aj1";
  };

  enableParallelBuilding = false;

  outputs = [ "dev" "out" "doc" "man" ];

  postInstall = ''
    mkdir -p $doc/share/doc/libffcall
    mv $out/share/html $doc/share/doc/libffcall
    rm -rf $out/share
  '';

  meta = with stdenv.lib; {
    description = "Foreign function call library";
    homepage = https://www.gnu.org/software/libffcall/;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
