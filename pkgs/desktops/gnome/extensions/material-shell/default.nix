{ stdenv, pkgs, lib, fetchFromGitHub, nix-gitignore, gnome, glib, nodejs }:
let
  ver = "40.a";
  source = fetchFromGitHub {
    owner = "material-shell";
    repo = "material-shell";
    rev = ver;
    sha256 = "Plzjid2X6C5NM/OWaMk78FKUwNT1taubFBtYw1dNIRw=";
  };
  nodeDependencies = (import ./node-composition.nix {
    inherit pkgs;
    inherit (stdenv.hostPlatform) system;
  }).nodeDependencies.override (oa: {
    src = source;
  });
in stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-material-shell";
  version = ver;

  src = source;

  buildInputs = [
    glib.dev
    nodejs
    nodeDependencies
  ];

  buildPhase = ''
    runHook preBuild
    ln -s "${nodeDependencies}/lib/node_modules" ./node_modules
    export PATH="${nodeDependencies}/bin:$PATH"
    make compile
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp -r dist/* $out/share/gnome-shell/extensions/${uuid}/
    runHook postInstall
  '';

  uuid = "material-shell@papyelgringo";

  meta = with lib; {
    description = "A modern desktop interface for Linux";
    license = licenses.mit;
    maintainers = with maintainers; [ benley ];
    homepage = "https://github.com/material-shell/material-shell";
    platforms = gnome.gnome-shell.meta.platforms;
  };
}
