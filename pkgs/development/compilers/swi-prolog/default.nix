{ lib, stdenv, fetchFromGitHub, jdk, gmp, readline, openssl, unixODBC, zlib
, libarchive, db, pcre2, libedit, libossp_uuid, libxcrypt,libXpm
, libSM, libXt, freetype, pkg-config, fontconfig
, cmake, libyaml, Security
, libjpeg, libX11, libXext, libXft, libXinerama
, extraLibraries ? [ jdk unixODBC libXpm libSM libXt freetype fontconfig ]
# Packs must be installed from a local directory during the build, with dependencies
# resolved manually, e.g. to install the 'julian' pack, which depends on the 'delay', 'list_util' and 'typedef' packs:
#   julian = pkgs.fetchzip {
#     name = "swipl-pack-julian";
#     url = "https://github.com/mndrix/julian/archive/v0.1.3.zip";
#     sha256 = "1sgql7c21p3c5m14kwa0bcmlwn9fql612krn9h36gla1j9yjdfgy";
#   };
#   delay = pkgs.fetchzip {
#     name = "swipl-pack-delay";
#     url = "https://github.com/mndrix/delay/archive/v0.3.3.zip";
#     sha256 = "0ira87afxnc2dnbbmgwmrr8qvary8lhzvhqwd52dccm6yqd3nybg";
#   };
#   list_util = pkgs.fetchzip {
#     name = "swipl-pack-list_util";
#     url = "https://github.com/mndrix/list_util/archive/v0.13.0.zip";
#     sha256 = "0lx7vffflak0y8l8vg8k0g8qddwwn23ksbz02hi3f8rbarh1n89q";
#   };
#   typedef = builtins.fetchTarball {
#     name = "swipl-pack-typedef";
#     url = "https://raw.githubusercontent.com/samer--/prolog/master/typedef/release/typedef-0.1.9.tgz";
#     sha256 = "056nqjn01g18fb1b2qivv9s7hb4azk24nx2d4kvkbmm1k91f44p3";
#   };
#   swiProlog = pkgs.swiProlog.override { extraPacks = map (dep-path: "'file://${dep-path}'") [
#     julian delay list_util typedef
#   ]; };
, extraPacks ? []
, withGui ? false
}:

let
  version = "9.1.21";
  packInstall = swiplPath: pack:
    ''${swiplPath}/bin/swipl -g "pack_install(${pack}, [package_directory(\"${swiplPath}/lib/swipl/pack\"), silent(true), interactive(false)])." -t "halt."
    '';
in
stdenv.mkDerivation {
  pname = "swi-prolog";
  inherit version;

  src = fetchFromGitHub {
    owner = "SWI-Prolog";
    repo = "swipl-devel";
    rev = "V${version}";
    hash = "sha256-c4OSntnwIzo6lGhpyNVtNM4el5FGrn8kcz8WkDRfQhU=";
    fetchSubmodules = true;
  };

  # Add the packInstall path to the swipl pack search path
  postPatch = ''
    echo "user:file_search_path(pack, '$out/lib/swipl/pack')." >> boot/init.pl
  '';

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ gmp readline openssl
    libarchive libyaml db pcre2 libedit libossp_uuid libxcrypt
    zlib ]
  ++ lib.optionals (withGui && !stdenv.isDarwin) [ libXpm libX11 libXext libXft libXinerama libjpeg ]
  ++ extraLibraries
  ++ lib.optional stdenv.isDarwin Security;

  hardeningDisable = [ "format" ];

  cmakeFlags = [ "-DSWIPL_INSTALL_IN_LIB=ON" ];

  preInstall = ''
    mkdir -p $out/lib/swipl/pack
  '';

  postInstall = builtins.concatStringsSep "\n"
  ( builtins.map (packInstall "$out") extraPacks
  );

  meta = {
    homepage = "https://www.swi-prolog.org";
    description = "Prolog compiler and interpreter";
    license = lib.licenses.bsd2;
    mainProgram = "swipl";
    platforms = lib.platforms.linux ++ lib.optionals (!withGui) lib.platforms.darwin;
    maintainers = [ lib.maintainers.meditans ];
  };
}
