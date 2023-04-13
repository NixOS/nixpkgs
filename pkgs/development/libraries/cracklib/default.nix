let version = "2.9.8"; in
{ stdenv, lib, buildPackages, fetchurl, zlib, gettext
, wordlists ? [ (fetchurl {
  url = "https://github.com/cracklib/cracklib/releases/download/v${version}/cracklib-words-${version}.gz";
  hash = "sha256-WLOCTIDdO6kIsMytUdbhZx4woj/u1gf7jmORR2i8T4U=";
}) ]
}:

stdenv.mkDerivation rec {
  pname = "cracklib";
  inherit version;

  src = fetchurl {
    url = "https://github.com/${pname}/${pname}/releases/download/v${version}/${pname}-${version}.tar.bz2";
    hash = "sha256-H500OF6jqnzXwH+jiNwlgQrqnTwz4mDHE6Olhz1w44Y=";
  };

  nativeBuildInputs = lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) buildPackages.cracklib;
  buildInputs = [ zlib gettext ];

  postPatch = lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
    chmod +x util/cracklib-format
    patchShebangs util

  '' + ''
    ln -vs ${toString wordlists} dicts/
  '';

  postInstall = ''
    make dict-local
  '';
  doInstallCheck = true;
  installCheckTarget = "test";

  meta = with lib; {
    homepage    = "https://github.com/cracklib/cracklib";
    description = "A library for checking the strength of passwords";
    license = licenses.lgpl21; # Different license for the wordlist: http://www.openwall.com/wordlists
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
