{ lib, stdenvNoCC, fetchFromGitHub, unstableGitUpdater }:

stdenvNoCC.mkDerivation rec {
  pname = "scheme-manpages";
  version = "unstable-2023-08-13";

  src = fetchFromGitHub {
    owner = "schemedoc";
    repo = "manpages";
    rev = "c17abb7dfb733fede4cf776a932e9696ccc7a4f2";
    hash = "sha256-9s/1sJEA4nowzQRpySOFzY+PxiUdz1Z3D931rMet4CA=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/man
    cp -r man3/ man7/ $out/share/man/
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Unix manual pages for R6RS and R7RS";
    homepage = "https://github.com/schemedoc/manpages";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
