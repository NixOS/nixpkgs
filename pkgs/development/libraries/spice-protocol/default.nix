{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "spice-protocol";
  version = "0.14.0";

  src = fetchurl {
    url = "https://www.spice-space.org/download/releases/${pname}-${version}.tar.bz2";
    sha256 = "1b3f44c13pqsp7aabmcinfbmgl79038bp5548l5pjs16lcfam95n";
  };

  postInstall = ''
    mkdir -p $out/lib
    ln -sv ../share/pkgconfig $out/lib/pkgconfig
  '';

  meta = with stdenv.lib; {
    description = "Protocol headers for the SPICE protocol";
    homepage = https://www.spice-space.org/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ bluescreen303 ];
    platforms = platforms.linux;
  };
}
