{ lib, stdenv, fetchurl, python3, bzip2, zlib, gmp, boost
# Passed by version specific builders
, baseVersion, revision, sha256
, sourceExtension ? "tar.xz"
, extraConfigureFlags ? ""
, extraPatches ? [ ]
<<<<<<< HEAD
, badPlatforms ? [ ]
, postPatch ? null
, knownVulnerabilities ? [ ]
, CoreServices ? null
, Security ? null
=======
, postPatch ? null
, knownVulnerabilities ? [ ]
, CoreServices
, Security
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, ...
}:

stdenv.mkDerivation rec {
  pname = "botan";
  version = "${baseVersion}.${revision}";

<<<<<<< HEAD
  outputs = [ "out" "dev" ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchurl {
    name = "Botan-${version}.${sourceExtension}";
    urls = [
       "http://files.randombit.net/botan/v${baseVersion}/Botan-${version}.${sourceExtension}"
       "http://botan.randombit.net/releases/Botan-${version}.${sourceExtension}"
    ];
    inherit sha256;
  };
  patches = extraPatches;
  inherit postPatch;

<<<<<<< HEAD
  nativeBuildInputs = [ python3 ];
  buildInputs = [ bzip2 zlib gmp boost ]
    ++ lib.optionals stdenv.isDarwin [ CoreServices Security ];

  configurePhase = ''
    runHook preConfigure
    python configure.py --prefix=$out --with-bzip2 --with-zlib ${extraConfigureFlags}${lib.optionalString stdenv.cc.isClang " --cc=clang"} ${lib.optionalString stdenv.hostPlatform.isAarch64 " --cpu=aarch64"}
    runHook postConfigure
=======
  buildInputs = [ python3 bzip2 zlib gmp boost ]
    ++ lib.optionals stdenv.isDarwin [ CoreServices Security ];

  configurePhase = ''
    python configure.py --prefix=$out --with-bzip2 --with-zlib ${extraConfigureFlags}${lib.optionalString stdenv.cc.isClang " --cc=clang"}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  enableParallelBuilding = true;

  preInstall = ''
    if [ -d src/scripts ]; then
      patchShebangs src/scripts
    fi
  '';

  postInstall = ''
    cd "$out"/lib/pkgconfig
    ln -s botan-*.pc botan.pc || true
  '';

  doCheck = true;

  meta = with lib; {
    description = "Cryptographic algorithms library";
<<<<<<< HEAD
    maintainers = with maintainers; [ raskin thillux ];
    platforms = platforms.unix;
    license = licenses.bsd2;
    inherit badPlatforms;
=======
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.unix;
    license = licenses.bsd2;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit knownVulnerabilities;
  };
  passthru.updateInfo.downloadPage = "http://files.randombit.net/botan/";
}
