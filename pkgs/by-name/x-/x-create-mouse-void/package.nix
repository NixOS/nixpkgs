{
  stdenv,
  lib,
  libx11,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "x-create-mouse-void";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "cas--";
    repo = "XCreateMouseVoid";
    rev = version;
    hash = "sha256-rJThTrN/2H1/6GPJoF9GvyzKVYUk8R6aNS/9Xx/ZN5Q=";
  };

  buildInputs = [ libx11 ];

  installPhase = ''
    runHook preInstall
    mkdir -pv $out/bin
    cp -a XCreateMouseVoid $out/bin/x-create-mouse-void
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/cas--/XCreateMouseVoid";
    description = "Creates an undecorated black window and prevents the mouse from entering that window";
    platforms = lib.platforms.unix;
    license = lib.licenses.unfreeRedistributable;
    maintainers = [ ];
    mainProgram = "x-create-mouse-void";
  };
}
