{ 
  lib
  , stdenv
  , fetchurl
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zenroom";
  version = "3.5.0";

  src = fetchurl {
    url = "https://files.dyne.org/zenroom/nightly/zenroom-linux-amd64";
    hash = "sha256-9xhQPrez4pk1zCzCyBqmNF/mkfChcA38p/s8//AwpZ8=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    install -m 550 $src $out/bin/zenroom
  '';

  meta = with lib; {
    homepage = "https://zenroom.org/";
    description = "Crypto smart-contract executor.";
    longDescription = ''
      Zenroom is a tiny secure execution environment that integrates in any
      platform and application, even on a chip or a web page.
      It can authenticate, authorize access and execute human-readable
      smart contracts for blockchains, databases and much more.
      It helps to develop cryptography keeping it simple, understandable and
      maintainable.
    '';
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ jacksmithinsulander ];
    mainProgram = finalAttrs.pname;
    platforms = platforms.linux;
  };
})
