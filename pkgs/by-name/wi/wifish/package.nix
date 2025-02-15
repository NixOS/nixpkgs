{
  lib,
  stdenv,
  fetchFromGitHub,
  dialog,
  gawk,
  wpa_supplicant,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "wifish";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "bougyman";
    repo = "wifish";
    rev = version;
    sha256 = "sha256-eTErN6CfKDey/wV+9o9cBVaG5FzCRBiA9UicrMz3KBc=";
  };

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    sed -i -e 's|/var/lib/wifish|${placeholder "out"}/var/lib/wifish|' wifish
  '';

  dontConfigure = true;

  installPhase = ''
    install -D -m0644 awk/wscanparse.awk ${placeholder "out"}/var/lib/wifish/wscanparse.awk
    install -D -m0644 awk/wlistparse.awk ${placeholder "out"}/var/lib/wifish/wlistparse.awk
    install -D -m0644 awk/wscan2menu.awk ${placeholder "out"}/var/lib/wifish/wscan2menu.awk
    install -D -m0644 awk/iwparse.awk ${placeholder "out"}/var/lib/wifish/iwparse.awk
    install -D -m0755 wifish ${placeholder "out"}/bin/wifish
  '';

  postFixup = ''
    wrapProgram ${placeholder "out"}/bin/wifish \
      --prefix PATH ":" ${
        lib.makeBinPath [
          dialog
          gawk
          wpa_supplicant
        ]
      }
  '';

  meta = with lib; {
    homepage = "https://github.com/bougyman/wifish";
    description = "Simple wifi shell script for linux";
    mainProgram = "wifish";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ ];
    platforms = with platforms; linux;
  };
}
