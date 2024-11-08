{
  buildDotnetModule,
  fetchFromGitHub,
  lib,
}:

buildDotnetModule rec {
  pname = "VrcAdvert";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "galister";
    repo = "VrcAdvert";
    rev = "v${version}";
    hash = "sha256-noIu5LV0yva94Kmdr39zb0kKXDaIrQ8DIplCj3aTIbQ=";
  };

  nugetDeps = ./deps.nix;

  executables = [ "VrcAdvert" ];

  meta = {
    description = "Advertise your OSC app through OSCQuery";
    homepage = "https://github.com/galister/VrcAdvert";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ Scrumplex ];
    mainProgram = "VrcAdvert";
    platforms = lib.platforms.all;
  };
}
