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
, static ? stdenv.hostPlatform.isStatic # generates static libraries *only*
, ...
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "botan";
  version = "${baseVersion}.${revision}";

  __structuredAttrs = true;

  outputs = [ "out" "dev" ];

  src = fetchurl {
    name = "Botan-${finalAttrs.version}.${sourceExtension}";
    urls = [
       "http://files.randombit.net/botan/v${baseVersion}/Botan-${finalAttrs.version}.${sourceExtension}"
       "http://botan.randombit.net/releases/Botan-${finalAttrs.version}.${sourceExtension}"
    ];
    inherit hash;
  };
  patches = extraPatches;
  inherit postPatch;

  nativeBuildInputs = [ python3 ];
  buildInputs = [ bzip2 zlib gmp boost ]
    ++ lib.optionals stdenv.isDarwin [ CoreServices Security ];

  botanConfigureFlags = [
    "--prefix=${placeholder "out"}"
    "--with-bzip2"
    "--with-zlib"
  ] ++ lib.optionals stdenv.cc.isClang [
    "--cc=clang"
  ] ++ lib.optionals stdenv.hostPlatform.isAarch64 [
    "--cpu=aarch64"
  ] ++ lib.optionals static [
    "--enable-static-library"
    "--disable-shared-library"
  ];

  configurePhase = ''
    runHook preConfigure
    python configure.py ''${botanConfigureFlags[@]} ${extraConfigureFlags}
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
    mainProgram = "botan";
    maintainers = with maintainers; [ raskin thillux ];
    platforms = platforms.unix;
    license = licenses.bsd2;
    inherit badPlatforms;
    inherit knownVulnerabilities;
  };
  passthru.updateInfo.downloadPage = "http://files.randombit.net/botan/";
})
