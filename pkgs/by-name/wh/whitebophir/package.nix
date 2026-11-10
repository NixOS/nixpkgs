{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  runtimeShell,
}:

buildNpmPackage rec {
  pname = "whitebophir";
  version = "2.18.33";

  src = fetchFromGitHub {
    owner = "lovasoa";
    repo = "whitebophir";
    rev = "v${version}";
    hash = "sha256-4/Arhbv6Tqzbv6F7FqGLZl4qccYG3IACV47l3TCoUHE=";
  };

  inherit nodejs;

  npmDepsHash = "sha256-0sCLdxB4ouS4NlsJZjwSmHjd/mqAnNFB3yJyrk0FUyU=";

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
