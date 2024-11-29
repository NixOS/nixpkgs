{
  buildGoModule,
  lib,
  fetchFromGitHub,
  fetchYarnDeps,
  yarn,
  fixup-yarn-lock,
  nodejs,
  fetchpatch2,
}:

buildGoModule rec {
  pname = "wireguard-ui";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "ngoduykhanh";
    repo = "wireguard-ui";
    rev = "refs/tags/v${version}";
    hash = "sha256-fK7l9I2s0zSxG1g1oQ1KjJZUcypwS9DxnNN7lhVI+1s=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/ngoduykhanh/wireguard-ui/commit/2fdafd34ca6c8f7f1415a3a1d89498bb575a7171.patch?full_index=1";
      hash = "sha256-nq/TX+TKDB29NcPQ3pLWD0jcXubULuwqisn9IcEW8B8=";
    })
  ];

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-ps/GtdtDKA3y5o1GZpRG+z08lSzk8d9zgxb95kjr/gc=";
  };

  vendorHash = "sha256-FTjZ6wf0ym6kFJ58Z3E3shmbq9SaMwlXWeueHQXwkX4=";

  nativeBuildInputs = [
    yarn
    fixup-yarn-lock
    nodejs
  ];

  ldflags = [
    "-X main.appVersion=v${version}"
  ];

  preConfigure = ''
    # This is what prepare_assets.sh do.
    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror "$offlineCache"
    fixup-yarn-lock yarn.lock
    yarn --offline install

    mkdir -p "./assets/dist/js" "./assets/dist/css" && \
    cp -r "./node_modules/admin-lte/dist/js/adminlte.min.js" "./assets/dist/js/adminlte.min.js" && \
    cp -r "./node_modules/admin-lte/dist/css/adminlte.min.css" "./assets/dist/css/adminlte.min.css"

    cp -r "./custom" "./assets"

    mkdir -p "./assets/plugins" && \
    cp -r "./node_modules/admin-lte/plugins/jquery" \
    "./node_modules/admin-lte/plugins/fontawesome-free" \
    "./node_modules/admin-lte/plugins/bootstrap" \
    "./node_modules/admin-lte/plugins/icheck-bootstrap" \
    "./node_modules/admin-lte/plugins/toastr" \
    "./node_modules/admin-lte/plugins/jquery-validation" \
    "./node_modules/admin-lte/plugins/select2" \
    "./node_modules/jquery-tags-input" \
    "./assets/plugins/"
  '';

  meta = {
    description = "Web user interface to manage your WireGuard setup";
    changelog = "https://github.com/ngoduykhanh/wireguard-ui/releases/tag/v${version}";
    homepage = "https://github.com/ngoduykhanh/wireguard-ui";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    mainProgram = "wireguard-ui";
  };
}
