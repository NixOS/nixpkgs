{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  # dependencies
  nodejs_22,
  wl-clipboard,
  xclip,
  cmake,
  openssl,
  cacert,
}:

let
  libdatachannel = fetchFromGitHub {
    owner = "paullouisageneau";
    repo = "libdatachannel";
    tag = "v0.24.5";
    fetchSubmodules = true;
    hash = "sha256-rr3au3JMqLd/sjNtXtXY2mcuW0CeOgG+Xj2RgEQCWys=";
  };

  libdatachannelBuildDeps = stdenv.mkDerivation {
    name = "libdatachannel-build-deps";
    nativeBuildInputs = [
      nodejs_22
      cacert
    ];

    buildPhase = ''
      export HOME=$(mktemp -d)
      export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt    # needs cert for registry to resolve
      # copy package.json and package-lock.json to the build directory
      cp ${./package.json} package.json
      cp ${./package-lock.json} package-lock.json
      npm ci --ignore-scripts
      mkdir -p $out
      cp -r node_modules $out/
    '';

    dontUnpack = true;
    dontInstall = true;
    outputHashMode = "recursive";
    outputHash = "sha256-Psa2R99JFUHGCA3DsrKFYgC1D7KIY+Va/kDGuiRi/CQ=";
  };
in

buildNpmPackage (finalAttrs: {
  pname = "torlink";
  version = "1.4.1";
  src = fetchFromGitHub {
    owner = "baairon";
    repo = "torlink";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VXfYzwjhSS+zZCnGoRUCVGgmuRaV5KeYASASM4E9Xj4=";
  };
  __structuredAttrs = true;
  strictDeps = true;

  nodejs = nodejs_22;
  npmDepsHash = "sha256-y1Q9PvI2PeWxuGuoQRSRN4qXgXFops3jA4QW75wkC80=";
  npmFlags = [ "--ignore-scripts" ]; # ignore-scripts for ip-set broken preinstall

  nativeBuildInputs = [ cmake ];
  buildInputs = [ openssl ];
  dontUseCmakeConfigure = true; # override cmake default (no configure script)

  postBuild = ''
    node scripts/postbuild.cjs
  '';

  # build node-datachannel, and wrap clipboard
  postInstall = ''
    pushd $out/lib/node_modules/torlnk/node_modules/node-datachannel

    # link shared nixpkgs openssl
    substituteInPlace CMakeLists.txt \
      --replace-fail \
      'set(OPENSSL_USE_STATIC_LIBS TRUE)' \
      'set(OPENSSL_USE_STATIC_LIBS FALSE)'

    # merge build deps
    mkdir -p node_modules
    cp -r ${libdatachannelBuildDeps}/node_modules/. node_modules/
    patchShebangs --build node_modules

    export npm_config_nodedir=${lib.getDev nodejs_22}

    # redirect node-datachannel
    node_modules/.bin/cmake-js compile \
        --CDFETCHCONTENT_SOURCE_DIR_LIBDATACHANNEL=${libdatachannel} \
        --CDFETCHCONTENT_FULLY_DISCONNECTED=ON

    # trim build tree
    find build -mindepth 1 -maxdepth 1 -not -name Release -exec rm -rf {} +
    find build/Release -mindepth 1 -not -name 'node_datachannel.node' -exec rm -rf {} +
    popd

    # wrap clipboard
    wrapProgram $out/bin/torlnk \
      --prefix PATH : ${
        lib.makeBinPath [
          wl-clipboard
          xclip
        ]
      }
  '';

  meta = {
    description = "Torlink is a torrent finder that lives in your terminal, with zero setup and nothing to configure.";
    homepage = "https://github.com/baairon/torlink";
    changelog = "https://github.com/baairon/torlink/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ghastrum ];
    mainProgram = "torlnk";
    platforms = lib.platforms.linux;
  };
})
