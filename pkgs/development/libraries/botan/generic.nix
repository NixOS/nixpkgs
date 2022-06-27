{ lib
, stdenv
, fetchurl
, boost
, bzip2
, gmp
, python3
, sqlite
, xz
, zlib
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

  nativeBuildInputs = [
    python3
  ];

  buildInputs = [
    boost
    bzip2
    gmp
    sqlite
    xz
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    CoreServices
    Security
  ];

  configurePhase = ''
    runHook preConfigure
    python configure.py \
      --prefix=$out \
      --with-boost \
      --with-bzip2 \
      --with-lzma \
      --with-sqlite3 \
      --with-zlib \
      --with-os-features=getrandom,getentropy \
      ${lib.optionalString stdenv.cc.isClang "--cc=clang"} \
      ${lib.optionalString stdenv.hostPlatform.isAarch64 "--cpu=aarch64"} \
      ${extraConfigureFlags}
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
    homepage = "https://botan.randombit.net/";
    maintainers = with maintainers; [ raskin thillux ];
    platforms = platforms.unix;
    license = licenses.bsd2;
    inherit badPlatforms;
    inherit knownVulnerabilities;
  };
  passthru.updateInfo.downloadPage = "http://files.randombit.net/botan/";
}
