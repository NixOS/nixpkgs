{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  runtimeShell,
}:

buildNpmPackage rec {
  pname = "whitebophir";
  version = "2.18.44";

  src = fetchFromGitHub {
    owner = "lovasoa";
    repo = "whitebophir";
    rev = "v${version}";
    hash = "sha256-npod3hi2eSGgfqC+jPJL4V1hMpUIBwuS0pxq5598vcQ=";
  };

  inherit nodejs;

  npmDepsHash = "sha256-KCRiLRUbYZW2N+bzkj+jnoP5DdWaDdjDqH8CNK4YeQY=";

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

  meta = {
    description = "Online collaborative whiteboard that is simple, free, easy to use and to deploy";
    license = lib.licenses.agpl3Plus;
    homepage = "https://github.com/lovasoa/whitebophir";
    mainProgram = "whitebophir";
    maintainers = with lib.maintainers; [ iblech ];
    platforms = lib.platforms.unix;
  };
}
