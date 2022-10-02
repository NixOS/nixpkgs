{ lib, stdenv, fetchFromGitHub }: {
  bats-assert = stdenv.mkDerivation {
    pname = "bats-assert";
    version = "2.0.0";
    src = fetchFromGitHub {
      owner = "bats-core";
      repo = "bats-assert";
      rev = "v2.0.0";
      sha256 = "sha256-whSbAj8Xmnqclf78dYcjf1oq099ePtn4XX9TUJ9AlyQ=";
    };
    dontBuild = true;
    installPhase = ''
      mkdir -p "$out/share/bats"
      cp -r . "$out/share/bats/bats-assert"
    '';
    meta = {
      description = "Common assertions for Bats";
      platforms = lib.platforms.all;
      homepage = "https://github.com/bats-core/bats-assert";
      license = lib.licenses.cc0;
      maintainers = with lib.maintainers; [ infinisil ];
    };
  };

  bats-file = stdenv.mkDerivation {
    pname = "bats-file";
    version = "0.3.0";
    src = fetchFromGitHub {
      owner = "bats-core";
      repo = "bats-file";
      rev = "v0.3.0";
      sha256 = "sha256-3xevy0QpwNZrEe+2IJq58tKyxQzYx8cz6dD2nz7fYUM=";
    };
    dontBuild = true;
    installPhase = ''
      mkdir -p "$out/share/bats"
      cp -r . "$out/share/bats/bats-file"
    '';
    meta = {
      description = "Common filesystem assertions for Bats";
      platforms = lib.platforms.all;
      homepage = "https://github.com/bats-core/bats-file";
      license = lib.licenses.cc0;
      maintainers = with lib.maintainers; [ infinisil ];
    };
  };

  bats-support = stdenv.mkDerivation {
    pname = "bats-support";
    version = "0.3.0";
    src = fetchFromGitHub {
      owner = "bats-core";
      repo = "bats-support";
      rev = "v0.3.0";
      sha256 = "sha256-4N7XJS5XOKxMCXNC7ef9halhRpg79kUqDuRnKcrxoeo=";
    };
    dontBuild = true;
    installPhase = ''
      mkdir -p "$out/share/bats"
      cp -r . "$out/share/bats/bats-support"
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
