{
  lib,
  stdenv,
  fetchurl,
  perl,
}:

let
  version = "2.8.8";
  folder =
    with builtins;
    let
      parts = splitVersion version;
    in
    concatStringsSep "." [
      (elemAt parts 0)
      (elemAt parts 1)
    ];
in
stdenv.mkDerivation rec {
  pname = "hyphen";
  inherit version;

  nativeBuildInputs = [ perl ];

  src = fetchurl {
    url = "https://sourceforge.net/projects/hunspell/files/Hyphen/${folder}/${pname}-${version}.tar.gz";
    sha256 = "01ap9pr6zzzbp4ky0vy7i1983fwyqy27pl0ld55s30fdxka3ciih";
  };

  # Do not install the en_US dictionary.
  installPhase = ''
    runHook preInstall
    make install-libLTLIBRARIES
    make install-binSCRIPTS
    make install-includeHEADERS

    # license
    install -D -m644 COPYING "$out/share/licenses/${pname}/LICENSE"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Text hyphenation library";
    mainProgram = "substrings.pl";
    homepage = "https://sourceforge.net/projects/hunspell/files/Hyphen/";
    platforms = platforms.all;
    license = with licenses; [
      gpl2
      lgpl21
      mpl11
    ];
  };
}
