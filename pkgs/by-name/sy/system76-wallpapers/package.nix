{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  imagemagick,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "system76-wallpapers";
  version = "0-unstable-2024-04-26";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "system76-wallpapers";
    rev = "ff1e25c79d10c699dfb695374d5ae7b3f8031b2b";
    forceFetchGit = true;
    fetchLFS = true;
    hash = "sha256-5rddxbi/hRPy93DqswG54HzWK33Y5TteGB8SKjLXJZk=";
  };

  prePatch = ''
    cp ${./Makefile} Makefile
  '';

  nativeBuildInputs = [ imagemagick ];

  makeFlags = [ "prefix=$(out)" ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Wallpapers for System76 products";
    homepage = "https://system76.com/";
    license = with lib.licenses; [
      unfree # No license specified
    ];
    maintainers = with lib.maintainers; [ pandapip1 ];
    platforms = lib.platforms.all;
  };
}
