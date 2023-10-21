# "Building instructions" are at
# https://github.com/Xpl0itU/WiiUDownloader/blob/main/.github/workflows/linux.yml

{ lib
, buildGoModule
, fetchurl
, fetchFromGitHub
, pkg-config
, wrapGAppsHook
, python3 # for preBuild script
, gtk3
}:

let
  # https://github.com/Xpl0itU/WiiUDownloader/blob/main/grabTitles.py
  # because this file changes frequently we're bundling it here.
  # Update it with this command:
  # curl --user-agent 'NUSspliBuilder/2.1' https://napi.nbg01.v10lator.de/db -o gtitles.c
  # Last updated: 22/10/2023
  gtitles = ./gtitles.c;
in buildGoModule rec {
  pname = "wiiudownloader";
  version = "2.27";

  src = fetchFromGitHub {
    owner = "Xpl0itU";
    repo = "WiiUDownloader";
    rev = "v${version}";
    hash = "sha256-03emjEcZ/d/9arMSStxz7fDNMgdAHF7R/VGnj5UrXg8=";
  };

  vendorHash = "sha256-fhi5y55p11xrn1eYmoxmZBXnu896WEhSV+vufq3RHZM=";

  postUnpack = ''
    ln -s ${gtitles} $sourceRoot/gtitles/gtitles.c
  '';

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook
    python3
  ];

  buildInputs = [
    gtk3
  ];

  ldflags = [ "-s" "-w" ];

  postPatch = ''
    substituteInPlace grabTitles.py \
      --replace 'checkAndDeleteFile("gtitles/gtitles.c")' ""
    sed -i '/urllib.request.urlretrieve/d' grabTitles.py
  '';

  preBuild = ''
    python3 grabTitles.py
  '';

  meta = with lib; {
    description = "Allows to download encrypted Wii U files from Nintendo's official servers";
    homepage = "https://github.com/Xpl0itU/WiiUDownloader";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ TheBrainScrambler ];
    platforms = platforms.linux;
  };
}
