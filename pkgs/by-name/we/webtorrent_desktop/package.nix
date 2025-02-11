{
  lib,
  stdenv,
  electron,
  buildNpmPackage,
  fetchFromGitHub,
  fetchpatch,
}:

buildNpmPackage {
  pname = "webtorrent-desktop";
  version = "0.25-pre-ac7f16";
  src = fetchFromGitHub {
    owner = "webtorrent";
    repo = "webtorrent-desktop";
    rev = "ac7f16e71c96c5ad670bfcb8728df5af78ae21a1";
    sha256 = "sha256-UEN5NhLVSQEO8rsiTW1hJPjNFL9KobW/Bho98FzKaf4=";
  };
  patches = [
    # startup fix
    (fetchpatch {
      name = "2389.patch"; # https://github.com/webtorrent/webtorrent-desktop/pull/2389
      url = "https://github.com/webtorrent/webtorrent-desktop/commit/407046d150ed7ff876a5e1978f68630e9c8f0074.patch";
      hash = "sha256-hBJGLNNjcGRhYOFlLm/RL0po+70tEeJtR6Y/CfacPAI=";
    })
  ];
  npmDepsHash = "sha256-otAes6GkqoAVvfeWhWgyY4IVZIZxw3WtkrVdEWIk1Lk=";
  makeCacheWritable = true;
  npmRebuildFlags = [ "--ignore-scripts" ];
  installPhase = ''
    ## Rebuild node_modules for production
    ## after babel compile has finished
    rm -r node_modules
    export NODE_ENV=production
    npm ci --ignore-scripts

    ## delete unused files
    rm -r test

    ## delete config for build time cache
    npm config delete cache

    ## add script wrapper and desktop files; icons
    mkdir -p $out/lib $out/bin $out/share/applications
    cp -r . $out/lib/webtorrent-desktop
    cat > $out/bin/WebTorrent <<EOF
    #! ${stdenv.shell}
    set -eu
    exec ${electron}/bin/electron --no-sandbox $out/lib/webtorrent-desktop "\$@"
    EOF
    chmod +x $out/bin/WebTorrent
    cp -r static/linux/share/icons $out/share/
    sed "s#/opt/webtorrent-desktop#$out/bin#" \
      < static/linux/share/applications/webtorrent-desktop.desktop \
      > $out/share/applications/webtorrent-desktop.desktop
  '';

  meta = with lib; {
    description = "Streaming torrent app for Mac, Windows, and Linux";
    homepage = "https://webtorrent.io/desktop";
    license = licenses.mit;
    maintainers = [ maintainers.bendlas ];
    mainProgram = "WebTorrent";
  };

}
