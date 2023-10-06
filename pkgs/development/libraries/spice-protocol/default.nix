{ lib, stdenv, fetchurl, meson, ninja }:

stdenv.mkDerivation rec {
  pname = "spice-protocol";
  version = "0.14.4";

  src = fetchurl {
    url = "https://www.spice-space.org/download/releases/${pname}-${version}.tar.xz";
    sha256 = "sha256-BP+6YQ2f1EHPxH36oTXXAJbmCxBG0hGdjbL46g0X2RI=";
  };

  nativeBuildInputs = [ meson ninja ];

  postInstall = ''
    mkdir -p $out/lib
    ln -sv ../share/pkgconfig $out/lib/pkgconfig
  '';

  meta = with lib; {
    description = "Protocol headers for the SPICE protocol";
    homepage = "https://www.spice-space.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bluescreen303 ];
    platforms = platforms.all;
  };
}
