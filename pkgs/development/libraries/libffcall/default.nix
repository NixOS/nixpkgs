{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libffcall-${version}";
  version = "2.1";

  src = fetchurl {
    url = "mirror://gnu/libffcall/libffcall-${version}.tar.gz";
    sha256 = "0iwcad6w78jp84vd6xaz5fwqm84n3cb42bdf5m5cj5xzpa5zp4d0";
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
