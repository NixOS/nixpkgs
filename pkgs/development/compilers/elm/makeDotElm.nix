{stdenv, lib, fetchurl, registryDat}:

ver: deps:
  let cmds = lib.mapAttrsToList (name: info: let
               pkg = stdenv.mkDerivation {
                 name = lib.replaceStrings ["/"] ["-"] name + "-${info.version}";

                 src = fetchurl {
                   url = "https://github.com/${name}/archive/${info.version}.tar.gz";
                   meta.homepage = "https://github.com/${name}/";
                   inherit (info) sha256;
                 };

                 configurePhase = ''
                   true
                 '';

                 buildPhase = ''
                   true
                 '';

                 installPhase = ''
                   mkdir -p $out
                   cp -r * $out
                 '';
               };
             in ''
               mkdir -p .elm/${ver}/packages/${name}
               cp -R ${pkg} .elm/${ver}/packages/${name}/${info.version}
             '') deps;
  in (lib.concatStrings cmds) + ''
    mkdir -p .elm/${ver}/packages;
    cp ${registryDat} .elm/${ver}/packages/registry.dat;
    chmod -R +w .elm
  ''
