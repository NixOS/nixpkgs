{ stdenv, lib, pkgs, fetchFromGitHub, fetchpatch, makeWrapper
, inkscape, nodejs, mkYarnPackage, python3, python3Packages }:

let
  pname = "hastygram";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "zopieux";
    repo = pname;
    rev = "v${version}";
    sha256 = "0q4wy02rswadnn1fi3g7i8z6ixlvnxkdfn9nv2h4xallig49768q";
  };

  frontend = mkYarnPackage {
    inherit pname version;

    src = "${src}/web";

    nativeBuildInputs = [ makeWrapper inkscape ];

    yarnNix = ./yarn-dependencies.nix;
    packageJSON = ./package.json;

    # yarnPreBuild and pkgConfig are necessary boilerplate to have node-sass
    # correctly compile and be available for $ npm run build.
    yarnPreBuild = ''
      mkdir -p $HOME/.node-gyp/${nodejs.version}
      echo 9 > $HOME/.node-gyp/${nodejs.version}/installVersion
      ln -sfv ${nodejs}/include $HOME/.node-gyp/${nodejs.version}
    '';

    pkgConfig = {
      node-sass = {
        buildInputs = with pkgs; [ python libsass pkgconfig ];
        postInstall = ''
          LIBSASS_EXT=auto yarn --offline run build
          rm build/config.gypi
        '';
      };
    };

    buildPhase = ''
      runHook preBuild
      cd deps/hastygram
      make -j$NIX_BUILD_CORES
      npm run build
      runHook postBuild
    '';

    dontInstall = true;

    distPhase = ''
      runHook preDist
      mv build $out
      runHook postDist
    '';
  };

in
python3Packages.buildPythonPackage rec {
  inherit pname version src;

  propagatedBuildInputs = with python3Packages; [ aiohttp fastapi ];

  postInstall = ''
    cp -r "${frontend}" "$out/frontend"
  '';

  # Upstream has no unit-tests.
  doCheck = false;

  meta = with lib; {
    description = "A lightweight frontend for Instagram";
    license = licenses.gpl3Plus;
    homepage = "https://github.com/zopieux/hastygram";
    maintainers = with maintainers; [ zopieux ];
  };
}
