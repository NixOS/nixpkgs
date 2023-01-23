{ mkDerivation, fetchurl, makeWrapper, unzip, lib, php }:

let
  pname = "n98-magerun";
  version = "2.3.0";
in
mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://files.magerun.net/n98-magerun-${version}.phar";
    sha256 = "b3e09dafccd4dd505a073c4e8789d78ea3def893cfc475a214e1154bff3aa8e4";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -D $src $out/libexec/n98-magerun/n98-magerun-${version}.phar
    makeWrapper ${php}/bin/php $out/bin/n98-magerun \
      --add-flags "$out/libexec/n98-magerun/n98-magerun-${version}.phar" \
      --prefix PATH : ${lib.makeBinPath [ unzip ]}
    runHook postInstall
  '';

  meta = with lib; {
    description = "The swiss army knife for Magento developers";
    license = licenses.mit;
    homepage = "https://magerun.net/";
    changelog = "https://magerun.net/category/magerun/";
    maintainers = teams.php.members;
  };
}
