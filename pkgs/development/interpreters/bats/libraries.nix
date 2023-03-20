{ lib, stdenv, fetchFromGitHub }: {
  bats-assert = stdenv.mkDerivation rec {
    pname = "bats-assert";
    version = "2.1.0";
    src = fetchFromGitHub {
      owner = "bats-core";
      repo = "bats-assert";
      rev = "v${version}";
      sha256 = "sha256-opgyrkqTwtnn/lUjMebbLfS/3sbI2axSusWd5i/5wm4=";
    };
    dontBuild = true;
    installPhase = ''
      mkdir -p "$out/share/bats/bats-assert"
      cp load.bash "$out/share/bats/bats-assert"
      cp -r src "$out/share/bats/bats-assert"
    '';
    meta = {
      description = "Common assertions for Bats";
      platforms = lib.platforms.all;
      homepage = "https://github.com/bats-core/bats-assert";
      license = lib.licenses.cc0;
      maintainers = with lib.maintainers; [ infinisil ];
    };
  };

  bats-file = stdenv.mkDerivation rec {
    pname = "bats-file";
    version = "0.3.0";
    src = fetchFromGitHub {
      owner = "bats-core";
      repo = "bats-file";
      rev = "v${version}";
      sha256 = "sha256-3xevy0QpwNZrEe+2IJq58tKyxQzYx8cz6dD2nz7fYUM=";
    };
    dontBuild = true;
    installPhase = ''
      mkdir -p "$out/share/bats/bats-file"
      cp load.bash "$out/share/bats/bats-file"
      cp -r src "$out/share/bats/bats-file"
    '';
    meta = {
      description = "Common filesystem assertions for Bats";
      platforms = lib.platforms.all;
      homepage = "https://github.com/bats-core/bats-file";
      license = lib.licenses.cc0;
      maintainers = with lib.maintainers; [ infinisil ];
    };
  };

  bats-support = stdenv.mkDerivation rec {
    pname = "bats-support";
    version = "0.3.0";
    src = fetchFromGitHub {
      owner = "bats-core";
      repo = "bats-support";
      rev = "v${version}";
      sha256 = "sha256-4N7XJS5XOKxMCXNC7ef9halhRpg79kUqDuRnKcrxoeo=";
    };
    dontBuild = true;
    installPhase = ''
      mkdir -p "$out/share/bats/bats-support"
      cp load.bash "$out/share/bats/bats-support"
      cp -r src "$out/share/bats/bats-support"
    '';
    meta = {
      description = "Supporting library for Bats test helpers";
      platforms = lib.platforms.all;
      homepage = "https://github.com/bats-core/bats-support";
      license = lib.licenses.cc0;
      maintainers = with lib.maintainers; [ infinisil ];
    };
  };
}
