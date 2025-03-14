{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_20,
  runtimeShell,
}:

let
  nodejs = nodejs_20;
in
buildNpmPackage rec {
  pname = "whitebophir";
  version = "1.19.1";

  src = fetchFromGitHub {
    owner = "lovasoa";
    repo = "whitebophir";
    rev = "v${version}";
    hash = "sha256-4T7s9WrpyHVPcw0QY0C0sczDJYKzA4bAAfEv8q2pOy4=";
  };

  inherit nodejs;

  npmDepsHash = "sha256-mKDkkX7vWrnfEg1D65bqn/MtyUS0DKjTtkDW6ebso7g=";

  # geckodriver tries to access network
  npmFlags = [ "--ignore-scripts" ];

  dontNpmBuild = true;

  postInstall = ''
    out_whitebophir=$out/lib/node_modules/whitebophir

    mkdir $out/bin
    cat <<EOF > $out/bin/whitebophir
    #!${runtimeShell}
    exec ${nodejs}/bin/node $out_whitebophir/server/server.js
    EOF
    chmod +x $out/bin/whitebophir
  '';

  meta = with lib; {
    description = "Online collaborative whiteboard that is simple, free, easy to use and to deploy";
    license = licenses.agpl3Plus;
    homepage = "https://github.com/lovasoa/whitebophir";
    mainProgram = "whitebophir";
    maintainers = with maintainers; [ iblech ];
    platforms = platforms.unix;
  };
}
