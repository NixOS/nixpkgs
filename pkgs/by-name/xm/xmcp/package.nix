{ lib
, stdenv
, fetchFromGitHub
, libX11
}:

stdenv.mkDerivation rec {
  pname = "xmcp";
  version = "unstable-2020-10-10";

  src = fetchFromGitHub {
    owner = "blblapco";
    repo = "xmcp";
    rev = "ee56225f1665f9edc04fe5c165809f2fe160a420";
    sha256 = "sha256-B3YkYrVEg6UJ2ApaVook4N2XvrCboxDMUG5CN9I79Sg=";
  };

  buildInputs = [ libX11 ];

  installPhase = ''
    runHook preInstall
    install -Dm0755 xmcp $out/bin/xmcp
    runHook postInstall
  '';

  meta = with lib; {
    description = "Tiny color picker for X11";
    homepage = "https://github.com/blblapco/xmcp";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.linux;
    mainProgram = "xmcp";
  };
}
