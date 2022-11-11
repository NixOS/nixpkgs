{ lib, stdenv, fetchurl, python3, bzip2, zlib, gmp, boost
# Passed by version specific builders
, baseVersion, revision, sha256
, sourceExtension ? "tar.xz"
, extraConfigureFlags ? ""
, extraPatches ? [ ]
, postPatch ? null
, knownVulnerabilities ? [ ]
, CoreServices
, Security
, ...
}:

stdenv.mkDerivation rec {
  pname = "botan";
  version = "${baseVersion}.${revision}";

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

  buildInputs = [ python3 bzip2 zlib gmp boost ]
    ++ lib.optionals stdenv.isDarwin [ CoreServices Security ];

  configurePhase = ''
    python configure.py --prefix=$out --with-bzip2 --with-zlib ${extraConfigureFlags}${if stdenv.cc.isClang then " --cc=clang" else "" }
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

  meta = with lib; {
    description = "Cryptographic algorithms library";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.unix;
    license = licenses.bsd2;
    inherit knownVulnerabilities;
  };
  passthru.updateInfo.downloadPage = "http://files.randombit.net/botan/";
}
