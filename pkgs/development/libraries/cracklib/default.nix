let version = "2.10.0"; in
{ stdenv, lib, buildPackages, fetchurl, zlib, gettext, fetchpatch2
, lists ? [ (fetchurl {
  url = "https://github.com/cracklib/cracklib/releases/download/v${version}/cracklib-words-${version}.gz";
  hash = "sha256-JDLo/bSLIijC2DUl+8Q704i2zgw5cxL6t68wvuivPpY=";
}) ]
}:

stdenv.mkDerivation rec {
  pname = "cracklib";
  inherit version;

  src = fetchurl {
    url = "https://github.com/${pname}/${pname}/releases/download/v${version}/${pname}-${version}.tar.bz2";
    hash = "sha256-cAw5YMplCx6vAhfWmskZuBHyB1o4dGd7hMceOG3V51Y=";
  };

  patches = lib.optionals stdenv.isDarwin [
    # Fixes build failure on Darwin due to missing byte order functions.
    # https://github.com/cracklib/cracklib/pull/96
    (fetchpatch2 {
      url = "https://github.com/cracklib/cracklib/commit/dff319e543272c1fb958261cf9ee8bb82960bc40.patch";
      hash = "sha256-QaWpEVV6l1kl4OIkJAqkXPVThbo040Rv9X2dY/+syqs=";
      stripLen = 1;
    })
  ];

  nativeBuildInputs = lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) buildPackages.cracklib;
  buildInputs = [ zlib gettext ];

  postPatch = lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
    chmod +x util/cracklib-format
    patchShebangs util

  '' + ''
    ln -vs ${toString lists} dicts/
  '';

  postInstall = ''
    make dict-local
  '';
  doInstallCheck = true;
  installCheckTarget = "test";

  meta = with lib; {
    homepage    = "https://github.com/cracklib/cracklib";
    description = "Library for checking the strength of passwords";
    license = licenses.lgpl21; # Different license for the wordlist: http://www.openwall.com/wordlists
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
