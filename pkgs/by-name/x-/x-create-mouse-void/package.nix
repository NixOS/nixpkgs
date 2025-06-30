{
  stdenv,
  lib,
  xorg,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "x-create-mouse-void";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "cas--";
    repo = "XCreateMouseVoid";
    rev = version;
    sha256 = "151pv4gmzz9g6nd1xw94hmawlb5z8rgs1jb3x1zpvn3znd7f355c";
  };

  buildInputs = [ xorg.libX11 ];

  installPhase = ''
    runHook preInstall
    mkdir -pv $out/bin
    cp -a XCreateMouseVoid $out/bin/x-create-mouse-void
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/cas--/XCreateMouseVoid";
    description = "Creates an undecorated black window and prevents the mouse from entering that window";
    platforms = platforms.unix;
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ eigengrau ];
    mainProgram = "x-create-mouse-void";
  };
}
