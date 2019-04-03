{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "spice-protocol-0.12.15";

  src = fetchurl {
    url = "https://www.spice-space.org/download/releases/${name}.tar.bz2";
    sha256 = "06b461i4jv741in8617jjpfk28wk7zs9p7841njkf4sbm8xv4kcb";
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
