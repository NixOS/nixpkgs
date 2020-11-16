{ stdenv, fetchurl, meson, ninja, pkg-config, efl, pcre, mesa, nixosTests }:

stdenv.mkDerivation rec {
  pname = "terminology";
  version = "1.8.1";

  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1fxqjf7g30ix4qxi6366rrax27s3maxq43z2vakwnhz4mp49m9h4";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    efl
    pcre
    mesa
  ];

  mesonFlags = [
    "-D edje-cc=${efl}/bin/edje_cc"
  ];

  passthru.tests.test = nixosTests.terminal-emulators.terminology;

  meta = {
    description = "Powerful terminal emulator based on EFL";
    homepage = "https://www.enlightenment.org/about-terminology";
    license = stdenv.lib.licenses.bsd2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ matejc tstrobel ftrvxmtrx romildo ];
  };
}
