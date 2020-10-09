{ stdenv
, fetchFromGitHub
, ffmpeg
, libva
, openssl
, xorg
, python3
, ninja
, unzip
, fetchurl
, gn
, git
}:

let
  depot_tools = fetchurl {
    url = "https://storage.googleapis.com/chrome-infra/depot_tools.zip";
    sha256 =  "0msa9fphf1shw23mrapwhzp4g76mrqic76qhjsb93ccc7czi7gmh";
  };
in
stdenv.mkDerivation rec {
  pname = "libwebrtc";
  version = "83.git1.18721df";
    
  src = fetchFromGitHub {
    owner = "open-webrtc-toolkit";
    repo = "owt-deps-webrtc";
    rev = "18721dffbee8b3d946ddbccabb8d636de7e8f197"; # 83-sdk?
    sha256 = "13hzvk4p69xlvyyxn6vwycrsi9a7nr0gnj5na2dcvjcg6ws3zfz9";
  };

  buildInputs = [
    ffmpeg
    libva
    xorg.libXcomposite
    xorg.libXrandr
    openssl
  ];

  nativeBuildInputs = [
    python3
    ninja
    unzip
    gn
    git
  ];
  
  configurePhase = ''
    HOME=/tmp git config --global user.email "nix@nix"
    HOME=/tmp git config --global user.name "nix"
    HOME=/tmp git init
    HOME=/tmp git add .
    HOME=/tmp git commit -m "nixOS Build Fake-Commit"

    pushd ..
    ls
    unzip ${depot_tools} -d depot_tools
    patchShebangs depot_tools
    cp ${./gclient-conf} .gclient
    VPYTHON_BYPASS="manually managed python not supported by chrome operations" DEPOT_TOOLS_UPDATE=0 depot_tools/gclient sync --no-history
    popd
    mkdir -p out/Release
    cp ${./args.gn} out/Release/args.gn
  '';

  buildPhase = ''
    gn gen out/Release
  '';
}
