{
  stdenv,
  lib,
  fetchFromGitHub,
}:

let
  games = {
    ctf = {
      id = "ctf";
      version = "1.13";
      description = "'Capture The Flag' for Yamagi Quake II";
      sha256 = "sha256-4obmF/GkR+JDEPKCo45B8d/vjA6qpJ4y7YMFSo2lvjM=";
    };

    ground-zero = {
      id = "rogue";
      version = "2.16";
      description = "'Ground Zero' for Yamagi Quake II";
      sha256 = "sha256-jmqnc/qEzsh+aoM62y8EKQa6dYQ9KE4vxschID50+PA=";
    };

    the-reckoning = {
      id = "xatrix";
      version = "2.08";
      description = "'The Reckoning' for Yamagi Quake II";
      sha256 = "1wp9fg1q8nly2r9hh4394r1h4dxyni3lvdy7g419cz5s8hhn5msr";
    };
  };

  toDrv =
    title: data:
    stdenv.mkDerivation rec {
      inherit (data)
        id
        version
        description
        sha256
        ;
      inherit title;

      pname = "yquake2-${title}";

      src = fetchFromGitHub {
        inherit sha256;
        owner = "yquake2";
        repo = data.id;
        rev = "${lib.toUpper id}_${builtins.replaceStrings [ "." ] [ "_" ] version}";
      };

      env =
        # Uses `false` and `true` as enum constants, which are keywords in C23 (GCC 15 default)
        lib.optionalAttrs stdenv.cc.isGNU {
          NIX_CFLAGS_COMPILE = "-std=gnu17";
        };

      installPhase = ''
        runHook preInstall
        mkdir -p $out/lib/yquake2/${id}
        cp release/* $out/lib/yquake2/${id}
        runHook postInstall
      '';

      meta = {
        inherit (data) description;
        homepage = "https://www.yamagi.org/quake2/";
        license = lib.licenses.unfree;
        platforms = lib.platforms.unix;
        maintainers = with lib.maintainers; [ tadfisher ];
      };
    };

in
lib.mapAttrs toDrv games
