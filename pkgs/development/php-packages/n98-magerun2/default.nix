{ mkDerivation, fetchurl, makeWrapper, unzip, lib, php }:

let
  pname = "n98-magerun2";
  version = "6.1.1";
in
mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://files.magerun.net/n98-magerun2-${version}.phar";
    sha256 = "bf3b68aa35c3b46d0c618b695021e454250956e5e9a467f5da01abf027172245";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -D $src $out/libexec/n98-magerun2/n98-magerun2-${version}.phar
    makeWrapper ${php}/bin/php $out/bin/n98-magerun2 \
      --add-flags "$out/libexec/n98-magerun2/n98-magerun2-${version}.phar" \
      --prefix PATH : ${lib.makeBinPath [ unzip ]}
    runHook postInstall
  '';

  meta = with lib; {
    description = "The swiss army knife for Magento 2 developers";
    license = licenses.mit;
    homepage = "https://magerun.net/";
    changelog = "https://magerun.net/category/magerun/";
    maintainers = teams.php.member;
  };
}
