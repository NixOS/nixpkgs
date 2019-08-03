{stdenv, lib, fetchurl, versionsDat}:

ver: deps:
  let cmds = lib.mapAttrsToList (name: info: let
               pkg = stdenv.mkDerivation {
                 name = lib.replaceChars ["/"] ["-"] name + "-${info.version}";

                 src = fetchurl {
                   url = "https://github.com/${name}/archive/${info.version}.tar.gz";
                   meta.homepage = "https://github.com/${name}/";
                   inherit (info) sha256;
                 };

                 phases = [ "unpackPhase" "installPhase" ];

                 installPhase = ''
                   mkdir -p $out
                   cp -r * $out
                 '';

               };
             in ''
               mkdir -p .elm/${ver}/package/${name}
               cp -R ${pkg} .elm/${ver}/package/${name}/${info.version}
             '') deps;
  in (lib.concatStrings cmds) + ''
    mkdir -p .elm/${ver}/package;
    cp ${versionsDat} .elm/${ver}/package/versions.dat;
    chmod -R +w .elm
  ''
