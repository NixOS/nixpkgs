{ stdenv, fetchurl, meson, ninja, pkgconfig, efl, pcre, mesa, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "terminology";
  version = "1.7.0";

  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/${pname}/${pname}-${version}.tar.xz";
    sha256 = "11qan2k6w94cglysh95yxkbv6hw9x15ri927hkiy3k0hbmpbrxc8";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    makeWrapper
  ];

  buildInputs = [
    efl
    pcre
    mesa
  ];

  meta = {
    description = "Powerful terminal emulator based on EFL";
    homepage = "https://www.enlightenment.org/about-terminology";
    license = stdenv.lib.licenses.bsd2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ matejc tstrobel ftrvxmtrx romildo ];
  };
}
