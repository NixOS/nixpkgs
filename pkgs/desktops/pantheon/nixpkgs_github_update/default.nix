{ lib
, beamPackages
, makeWrapper
, common-updater-scripts
}:

let

  poison_4 = beamPackages.buildMix {
    name = "poison";
    version = "4.0.1";

    src = beamPackages.fetchHex {
      pkg = "poison";
      version = "4.0.1";
      sha256 = "098gdz7xzfmnjzgnnv80nl4h3zl8l9czqqd132vlnfabxbz3d25s";
    };
  };


in

beamPackages.buildMix {
  name = "nixpkgs-github-update";
  version = "0.1.0";

  src = lib.cleanSource ./.;

  nativeBuildInputs = [
    makeWrapper
  ];

  beamDeps = with beamPackages; [ erlang poison_4 ];

  buildPhase = ''
    export HEX_OFFLINE=1
    export HEX_HOME=`pwd`
    export MIX_ENV=prod
    export MIX_NO_DEPS=1

    mix escript.build --no-deps-check
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp nixpkgs_github_update $out/bin
  '';

  postFixup = ''
    wrapProgram $out/bin/nixpkgs_github_update \
      --prefix PATH : "${lib.makeBinPath [ common-updater-scripts ]}"
  '';
}
