{ lib, stdenv, fetchFromGitHub, libfaketime
, xorg
}:

stdenv.mkDerivation rec {
  pname = "creep2";
  version = "unstable-2021-03-25";

  src = fetchFromGitHub {
    owner = "raymond-w-ko";
    repo = pname;
    rev = "69dc0de03d89f31b8074981cec0be45d4aceb245";
    sha256 = "sha256-iVppvnqgui/KUZTqYeEX9Qw8k325ix40+AVG49qmGVw=";
  };

  nativeBuildInputs = [ libfaketime xorg.fonttosfnt xorg.mkfontscale ];

  buildPhase = ''
    runHook preBuild

    faketime -f "1970-01-01 00:00:01" fonttosfnt -g 2 -m 2 -o creep2.otb creep2-11.bdf

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 creep2.otb creep2-11.bdf -t "$out/share/fonts/misc/"
    insll -Dm644 creep2.ttf -t "$out/share/fonts/truetype"
    mkfontdir "$out/share/fonts/misc"
    mkfontscale "$out/share/fonts/truetype"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A copy of the 'creep' font by romeovs but with a strict character bounding box";
    homepage = "https://github.com/raymond-w-ko/creep2";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ dariof4 ];
  };
}
