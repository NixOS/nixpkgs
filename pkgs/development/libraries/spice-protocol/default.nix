{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "spice-protocol-0.12.13";

  src = fetchurl {
    url = "http://www.spice-space.org/download/releases/${name}.tar.bz2";
    sha256 = "0cwrgkp558mblcf4vrhacb3iizz12khsrrl82w38w9nj0ar13vl9";
  };

  postInstall = ''
    mkdir -p $out/lib
    ln -sv ../share/pkgconfig $out/lib/pkgconfig
  '';

  meta = with stdenv.lib; {
    description = "Protocol headers for the SPICE protocol";
    homepage = http://www.spice-space.org;
    license = licenses.bsd3;
    maintainers = with maintainers; [ bluescreen303 ];
    platforms = platforms.linux;
  };
}
