{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  runtimeShell,
}:

buildNpmPackage rec {
  pname = "whitebophir";
  version = "2.17.0";

  src = fetchFromGitHub {
    owner = "lovasoa";
    repo = "whitebophir";
    rev = "v${version}";
    hash = "sha256-A4w4dJHsYdBXClX0ZAb/th66uVD7zq+2AfnNXClIf44=";
  };

  inherit nodejs;

  npmDepsHash = "sha256-fXpv3CZsyHaCifyvbu1mXrJg1vLfTXaw+802FFv4eRQ=";

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
