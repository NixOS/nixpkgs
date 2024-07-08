{ lib
, rustPlatform
, fetchFromGitHub
, buildNpmPackage
, bash
, cmake
, cairo
, deno
, fetchurl
, go
, lld
, makeWrapper
, nsjail
, openssl
, pango
, pixman
, giflib
, pkg-config
, python3
, rustfmt
, stdenv
, swagger-cli
}:

let
  pname = "windmill";
  version = "1.333.2";

  src = fetchFromGitHub {
    owner = "windmill-labs";
    repo = "windmill";
    rev = "v${version}";
    hash = "sha256-QwjmkKe3jxgXQjj/+WlhOdGOXZsrYdRmHtVakoNqYtI=";
  };

  pythonEnv = python3.withPackages (ps: [ ps.pip-tools ]);

  frontend-build = buildNpmPackage {
    inherit version src;

    pname = "windmill-ui";

    sourceRoot = "${src.name}/frontend";

    npmDepsHash = "sha256-I9h2MvngsluWYaoOP44ufE82SFW+8yhNI2qQNi6oyZE=";

    # without these you get a
    # FATAL ERROR: Ineffective mark-compacts near heap limit Allocation failed - JavaScript heap out of memory
    env.NODE_OPTIONS="--max-old-space-size=8192";

    preBuild = ''
      npm run generate-backend-client
    '';

    buildInputs = [ pixman cairo pango giflib ];
    nativeBuildInputs = [ python3 pkg-config ];

    installPhase = ''
      mkdir -p $out/share
      mv build $out/share/windmill-frontend
    '';
  };
in
rustPlatform.buildRustPackage {
  inherit pname version;
  src = "${src}/backend";

  env = {
    SQLX_OFFLINE = "true";
    RUSTY_V8_ARCHIVE =
      let
        fetch_librusty_v8 = args:
          fetchurl {
            name = "librusty_v8-${args.version}";
            url = "https://github.com/denoland/rusty_v8/releases/download/v${args.version}/librusty_v8_release_${stdenv.hostPlatform.rust.rustcTarget}.a";
            sha256 = args.shas.${stdenv.hostPlatform.system} or (throw "Unsupported platform ${stdenv.hostPlatform.system}");
            meta = {
              inherit (args) version;
              sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
            };
          };
      in
      fetch_librusty_v8 {
        version = "0.83.2";
        shas = {
          x86_64-linux = "sha256-RJNdy5jRZK3dTgrHsWuZZAHUyy1EogyNNuBekZ3Arrk=";
          aarch64-linux = "sha256-mpOmuqtd7ob6xvrgH4P/6GLa/hXTS/ok0WOYo7+7ZhI=";
          x86_64-darwin = "sha256-2o8CvJ3r5+4PLNGTySqPPDTqbU0piX4D1UtZMscMdHU=";
          aarch64-darwin = "sha256-WHeITWSHjZxfQJndxcjsp4yIERKrKXSHFZ0UBc43p8o=";
        };
      };
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "archiver-rs-0.5.1" = "sha256-ZIik0mMABmhdx/ullgbOrKH5GAtqcOKq5A6vB7aBSjk=";
      "pg-embed-0.7.2" = "sha256-R/SrlzNK7aAOyXVTQ/WPkiQb6FyMg9tpsmPTsiossDY=";
      "php-parser-rs-0.1.3" = "sha256-ZeI3KgUPmtjlRfq6eAYveqt8Ay35gwj6B9iOQRjQa9A=";
      "progenitor-0.3.0" = "sha256-F6XRZFVIN6/HfcM8yI/PyNke45FL7jbcznIiqj22eIQ=";
      "rustpython-ast-0.3.1" = "sha256-q9N+z3F6YICQuUMp3a10OS792tCq0GiSSlkcaLxi3Gs=";
      "tiberius-0.12.2" = "sha256-s/S0K3hE+JNCrNVxoSCSs4myLHvukBYTwk2A5vZ7Ae8=";
      "tinyvector-0.1.0" = "sha256-NYGhofU4rh+2IAM+zwe04YQdXY8Aa4gTmn2V2HtzRfI=";
    };
  };

  patches = [
    ./swagger-cli.patch
    ./run.go.config.proto.patch
    ./run.python3.config.proto.patch
    ./run.bash.config.proto.patch
  ];

  postPatch = ''
    substituteInPlace windmill-worker/src/bash_executor.rs \
      --replace '"/bin/bash"' '"${bash}/bin/bash"'

    substituteInPlace windmill-api/src/lib.rs \
      --replace 'unknown-version' 'v${version}'

    substituteInPlace src/main.rs \
      --replace 'unknown-version' 'v${version}'

    pushd ..

    mkdir -p frontend/build
    cp -R ${frontend-build}/share/windmill-frontend/* frontend/build
    cp ${src}/openflow.openapi.yaml .

    popd
  '';

  buildInputs = [
    openssl
    rustfmt
    lld
    stdenv.cc.cc.lib
  ];

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    swagger-cli
    cmake # for libz-ng-sys crate
  ];

  # needs a postgres database running
  doCheck = false;

  postFixup = ''
    patchelf --set-rpath ${lib.makeLibraryPath [openssl]} $out/bin/windmill

    wrapProgram "$out/bin/windmill" \
      --prefix PATH : ${lib.makeBinPath [go pythonEnv deno nsjail bash]} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [stdenv.cc.cc.lib]} \
      --set PYTHON_PATH "${pythonEnv}/bin/python3" \
      --set GO_PATH "${go}/bin/go" \
      --set DENO_PATH "${deno}/bin/deno" \
      --set NSJAIL_PATH "${nsjail}/bin/nsjail"
  '';

  meta = {
    changelog = "https://github.com/windmill-labs/windmill/blob/${src.rev}/CHANGELOG.md";
    description = "Open-source developer platform to turn scripts into workflows and UIs";
    homepage = "https://windmill.dev";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ dit7ya happysalada ];
    mainProgram = "windmill";
    # limited by librusty_v8
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
}
