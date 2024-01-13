{ lib, stdenv, fetchurl, python3, bzip2, zlib, gmp, boost
# Passed by version specific builders
, baseVersion, revision, hash
, sourceExtension ? "tar.xz"
, extraConfigureFlags ? ""
, extraPatches ? [ ]
, badPlatforms ? [ ]
, postPatch ? null
, knownVulnerabilities ? [ ]
, CoreServices ? null
, Security ? null
, ...
}:

stdenv.mkDerivation rec {
  pname = "botan";
  version = "${baseVersion}.${revision}";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    name = "Botan-${version}.${sourceExtension}";
    urls = [
       "http://files.randombit.net/botan/v${baseVersion}/Botan-${version}.${sourceExtension}"
       "http://botan.randombit.net/releases/Botan-${version}.${sourceExtension}"
    ];
    inherit hash;
  };
  patches = extraPatches;
  inherit postPatch;

  nativeBuildInputs = [ python3 ];
  buildInputs = [ bzip2 zlib gmp boost ]
    ++ lib.optionals stdenv.isDarwin [ CoreServices Security ];

  configurePhase = ''
    runHook preConfigure
    python configure.py --prefix=$out --with-bzip2 --with-zlib ${extraConfigureFlags}${lib.optionalString stdenv.cc.isClang " --cc=clang"} ${lib.optionalString stdenv.hostPlatform.isAarch64 " --cpu=aarch64"}
    runHook postConfigure
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
    maintainers = with maintainers; [ raskin thillux ];
    platforms = platforms.unix;
    license = licenses.bsd2;
    inherit badPlatforms;
    inherit knownVulnerabilities;
  };
  passthru.updateInfo.downloadPage = "http://files.randombit.net/botan/";
}
