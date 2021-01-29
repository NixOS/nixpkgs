{ lib, stdenv, fetchurl, meson, ninja, pkg-config, python3, efl, pcre, mesa }:

stdenv.mkDerivation rec {
  pname = "terminology";
  version = "1.9.0";

  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0v74858yvrrfy0l2pq7yn6izvqhpkb9gw2jpd3a3khjwv8kw6frz";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    efl
    pcre
    mesa
  ];

  mesonFlags = [
    "-D edje-cc=${efl}/bin/edje_cc"
  ];

  postPatch = ''
    patchShebangs data/colorschemes/*.py
  '';

  meta = {
    description = "Powerful terminal emulator based on EFL";
    homepage = "https://www.enlightenment.org/about-terminology";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ matejc tstrobel ftrvxmtrx romildo ];
  };
}
