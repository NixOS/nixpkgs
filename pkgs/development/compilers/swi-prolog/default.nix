{ lib, stdenv, fetchFromGitHub, jdk, gmp, readline, openssl, unixODBC, zlib
, libarchive, db, pcre, libedit, libossp_uuid, libXpm
, libSM, libXt, freetype, pkg-config, fontconfig
, cmake, libyaml, Security
, libjpeg, libX11, libXext, libXft, libXinerama
, extraLibraries ? [ jdk unixODBC libXpm libSM libXt freetype fontconfig ]
, extraPacks     ? []
, withGui ? false
}:

let
  version = "8.3.9";
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
    sha256 = "0ixb8pc5s7q8q0njs8is1clpvik6jhhdcwnys7m9rpwdzgi10sjz";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ gmp readline openssl
    libarchive libyaml db pcre libedit libossp_uuid
    zlib ]
  ++ lib.optionals (withGui && !stdenv.isDarwin) [ libXpm libX11 libXext libXft libXinerama libjpeg ]
  ++ extraLibraries
  ++ lib.optional stdenv.isDarwin Security;

  hardeningDisable = [ "format" ];

  cmakeFlags = [ "-DSWIPL_INSTALL_IN_LIB=ON" ];

  postInstall = builtins.concatStringsSep "\n"
  ( builtins.map (packInstall "$out") extraPacks
  );

  meta = {
    homepage = "https://www.swi-prolog.org";
    description = "A Prolog compiler and interpreter";
    license = lib.licenses.bsd2;

    platforms = lib.platforms.linux ++ lib.optionals (!withGui) lib.platforms.darwin;
    maintainers = [ lib.maintainers.meditans ];
  };
}
