{ stdenv, fetchgit, jdk, gmp, readline, openssl, libjpeg, unixODBC, zlib
, libXinerama, libarchive, db, pcre, libedit, libossp_uuid, libXft, libXpm
, libSM, libXt, freetype, pkgconfig, fontconfig, makeWrapper ? stdenv.isDarwin
, git, cacert, cmake, libyaml
, extraLibraries ? [ jdk unixODBC libXpm libSM libXt freetype fontconfig ]
, extraPacks     ? []
}:

let
  version = "8.1.4";
  packInstall = swiplPath: pack:
    ''${swiplPath}/bin/swipl -g "pack_install(${pack}, [package_directory(\"${swiplPath}/lib/swipl/pack\"), silent(true), interactive(false)])." -t "halt."
    '';
in
stdenv.mkDerivation {
  name = "swi-prolog-${version}";

  src = fetchgit {
    url = "https://github.com/SWI-Prolog/swipl-devel";
    rev = "V${version}";
    sha256 = "0qxa6f5dypwczxajlf0l736adbjb17cbak3qsh5g04hpv2bxm6dh";
  };

  buildInputs = [ cacert git cmake gmp readline openssl
    libarchive libyaml db pcre libedit libossp_uuid
    zlib pkgconfig ]
  ++ extraLibraries
  ++ stdenv.lib.optional stdenv.isDarwin makeWrapper;

  hardeningDisable = [ "format" ];

  configureFlags = [
    "--with-world"
    "--enable-gmp"
    "--enable-shared"
  ];

  installPhase = ''
    mkdir -p $out
    mkdir build
    cd build
    ${cmake}/bin/cmake -DCMAKE_INSTALL_PREFIX=$out ..
    cd ../
    make
    make install
    make clean
    mkdir -p $out/lib/swipl/pack
  ''
  + builtins.concatStringsSep "\n"
  ( builtins.map (packInstall "$out") extraPacks
  );

  # For macOS: still not fixed in upstream: "abort trap 6" when called
  # through symlink, so wrap binary.
  # We reinvent wrapProgram here but omit argv0 pass in order to not
  # break PAKCS package build. This is also safe for SWI-Prolog, since
  # there is no wrapping environment and hence no need to spoof $0
  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    local prog="$out/bin/swipl"
    local hidden="$(dirname "$prog")/.$(basename "$prog")"-wrapped
    mv $prog $hidden
    makeWrapper $hidden $prog
  '';

  meta = {
    homepage = http://www.swi-prolog.org/;
    description = "A Prolog compiler and interpreter";
    license = "LGPL";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.meditans ];
  };
}
