{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "unicode-character-database";
  version = "18.0.0";

  src = fetchurl {
    url = "https://www.unicode.org/Public/${finalAttrs.version}/ucd/UCD.zip";
    sha256 = "sha256-ez5VVRQGC5IpDRVPU2VcXrD6YrFusEwDQ0/3LRpmoNg=";
  };
  __structuredAttrs = true;
  strictDeps = true;
  enableParallelBuilding = false; # nothing to build
  doCheck = false; # no tests to run

  nativeBuildInputs = [
    unzip
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/unicode
    cp -r * $out/share/unicode
    rm $out/share/unicode/env-vars

    runHook postInstall
  '';

  meta = {
    description = "Unicode Character Database";
    homepage = "https://www.unicode.org/";
    license = lib.licenses.unicode-30;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      sandarukasa
    ];
  };
})
