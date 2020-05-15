{ stdenv, fetchFromGitHub, jdk, gmp, readline, openssl, unixODBC, zlib
, libarchive, db, pcre, libedit, libossp_uuid, libXpm
, libSM, libXt, freetype, pkgconfig, fontconfig
, cmake, libyaml, Security
, libjpeg, libX11, libXext, libXft, libXinerama
, extraLibraries ? [ jdk unixODBC libXpm libSM libXt freetype fontconfig ]
, extraPacks     ? []
, withGui ? false
}:

let
  version = "8.1.15";
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
    sha256 = "0czbrscx2s4079nmwvipp9cnwfny16m3fpnp823llm7wyljchgvq";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ gmp readline openssl
    libarchive libyaml db pcre libedit libossp_uuid
    zlib ]
  ++ stdenv.lib.optionals (withGui && !stdenv.isDarwin) [ libXpm libX11 libXext libXft libXinerama libjpeg ]
  ++ extraLibraries
  ++ stdenv.lib.optional stdenv.isDarwin Security;

  hardeningDisable = [ "format" ];

  cmakeFlags = [ "-DSWIPL_INSTALL_IN_LIB=ON" ];

  postInstall = builtins.concatStringsSep "\n"
  ( builtins.map (packInstall "$out") extraPacks
  );

  meta = {
    homepage = "https://www.swi-prolog.org";
    description = "A Prolog compiler and interpreter";
    license = stdenv.lib.licenses.bsd2;

    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.optionals (!withGui) stdenv.lib.platforms.darwin;
    maintainers = [ stdenv.lib.maintainers.meditans ];
  };
}
