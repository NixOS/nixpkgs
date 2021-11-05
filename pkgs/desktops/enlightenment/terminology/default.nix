{ lib, stdenv, fetchurl, meson, ninja, pkg-config, python3, efl, pcre, mesa }:

stdenv.mkDerivation rec {
  pname = "terminology";
  version = "1.10.0";

  src = fetchurl {
    url = "https://download.enlightenment.org/rel/apps/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0imk7cjkcjss3zf4hjwmy54pbizm6l6pq553jcx7bpsnhs56bbsz";
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

  meta = with lib; {
    description = "Powerful terminal emulator based on EFL";
    homepage = "https://www.enlightenment.org/about-terminology";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ matejc tstrobel ftrvxmtrx romildo ];
  };
}
