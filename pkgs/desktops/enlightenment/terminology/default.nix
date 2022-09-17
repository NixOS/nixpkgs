{ lib, stdenv, fetchurl, meson, ninja, pkg-config, python3, efl, nixosTests }:

stdenv.mkDerivation rec {
  pname = "terminology";
  version = "1.12.1";

  src = fetchurl {
    url = "https://download.enlightenment.org/rel/apps/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1aasddf2343qj798b5s8qwif3lxj4pyjax6fa9sfi6if9icdkkpq";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    efl
  ];

  postPatch = ''
    patchShebangs data/colorschemes/*.py
  '';

  passthru.tests.test = nixosTests.terminal-emulators.terminology;

  meta = with lib; {
    description = "Powerful terminal emulator based on EFL";
    homepage = "https://www.enlightenment.org/about-terminology";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ matejc ftrvxmtrx ] ++ teams.enlightenment.members;
  };
}
