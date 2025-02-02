{ lib
, stdenvNoCC
, fetchFromGitHub
, patsh
, xorg
}:

stdenvNoCC.mkDerivation rec {
  pname = "sx";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "earnestly";
    repo = pname;
    rev = version;
    hash = "sha256-hKoz7Kuus8Yp7D0F05wCOQs6BvV0NkRM9uUXTntLJxQ=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  nativeBuildInputs = [ patsh ];

  buildInputs = [
    xorg.xauth
    xorg.xorgserver
  ];

  postInstall = ''
    patsh -f $out/bin/sx -s ${builtins.storeDir}
  '';

  meta = with lib; {
    description = "Simple alternative to both xinit and startx for starting a Xorg server";
    homepage = "https://github.com/earnestly/sx";
    license = licenses.mit;
    mainProgram = "sx";
    maintainers = with maintainers; [ figsoda thiagokokada ];
    platforms = platforms.linux;
  };
}
