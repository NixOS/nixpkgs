{ pkgs, system, lib, makeWrapper, gh, git, nodejs, php }:

let
  package = (import ./composition.nix {
    inherit pkgs system;
    noDev = true; # Disable development dependencies
  });

in package.override rec {
  version = "4.2.7";

  nativeBuildInputs = [ makeWrapper ];
  postInstall = ''
    wrapProgram $out/bin/laravel --suffix PATH : "${lib.makeBinPath [ gh git nodejs php.packages.composer ]}"
  '';

  meta = with lib; {
    description = "As easy as possible to get started with Laravel";
    homepage = "https://laravel.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ aanderse ];
    platforms = platforms.all;
  };
}
