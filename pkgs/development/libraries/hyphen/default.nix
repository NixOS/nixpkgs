{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hyphen";
  version = "2.8.9";

  nativeBuildInputs = [
    autoreconfHook
    perl
  ];

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "hunspell";
    repo = "hyphen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-F7PJQjEiE5t5i1gi5B8wzrwAJQl8FWzopRA8uDsaZBc=";
  };

  enableParallelBuilding = true;

  # Do not install the en_US dictionary.
  installPhase = ''
    runHook preInstall
    make install-libLTLIBRARIES
    make install-binSCRIPTS
    make install-includeHEADERS

    # license
    install -D -m644 COPYING "$out/share/licenses/hyphen/LICENSE"
    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/hunspell/hyphen/blob/${finalAttrs.src.tag}/NEWS";
    description = "Text hyphenation library";
    mainProgram = "substrings.pl";
    homepage = "https://github.com/hunspell/hyphen";
    platforms = lib.platforms.all;
    license = with lib.licenses; [
      gpl2
      lgpl21
      mpl11
    ];
  };
})
