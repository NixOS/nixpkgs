{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  python3,
  efl,
  nixosTests,
  directoryListingUpdater,
}:

stdenv.mkDerivation rec {
  pname = "terminology";
  version = "1.13.0";

  src = fetchurl {
    url = "https://download.enlightenment.org/rel/apps/${pname}/${pname}-${version}.tar.xz";
    sha256 = "FqN/7Ne71j7J3j7GwK8zHO531t/ag4obFXPW8phHTaU=";
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

  passthru.updateScript = directoryListingUpdater { };

  meta = with lib; {
    description = "Powerful terminal emulator based on EFL";
    homepage = "https://www.enlightenment.org/about-terminology";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers =
      with maintainers;
      [
        matejc
        ftrvxmtrx
      ]
      ++ teams.enlightenment.members;
  };
}
