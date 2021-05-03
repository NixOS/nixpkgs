{ stdenv, fetchurl, meson, ninja }:

stdenv.mkDerivation rec {
  pname = "spice-protocol";
  version = "0.14.3";

  src = fetchurl {
    url = "https://www.spice-space.org/download/releases/${pname}-${version}.tar.xz";
    sha256 = "0yj8k7gcirrsf21w0q6146n5g4nzn2pqky4p90n5760m5ayfb1pr";
  };

  nativeBuildInputs = [ meson ninja ];

  postInstall = ''
    mkdir -p $out/lib
    ln -sv ../share/pkgconfig $out/lib/pkgconfig
  '';

  meta = with stdenv.lib; {
    description = "Protocol headers for the SPICE protocol";
    homepage = "https://www.spice-space.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bluescreen303 ];
    platforms = platforms.linux;
  };
}
