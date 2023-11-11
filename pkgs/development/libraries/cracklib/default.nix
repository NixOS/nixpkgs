let version = "2.9.11"; in
{ stdenv, lib, buildPackages, fetchurl, zlib, gettext
, lists ? [ (fetchurl {
  url = "https://github.com/cracklib/cracklib/releases/download/v${version}/cracklib-words-${version}.gz";
  hash = "sha256-popxGjE1c517Z+nzYLM/DU7M+b1/rE0XwNXkVqkcUXo=";
}) ]
}:

stdenv.mkDerivation rec {
  pname = "cracklib";
  inherit version;

  src = fetchurl {
    url = "https://github.com/${pname}/${pname}/releases/download/v${version}/${pname}-${version}.tar.bz2";
    hash = "sha256-yosEmjwtOyIloejRXWE3mOvHSOOVA4jtomlN5Qe6YCA=";
  };

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
    description = "A library for checking the strength of passwords";
    license = licenses.lgpl21; # Different license for the wordlist: http://www.openwall.com/wordlists
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
