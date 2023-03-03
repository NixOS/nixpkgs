{ mkDerivation, fetchurl, makeWrapper, lib, php }:

mkDerivation rec {
  pname = "phive";
  version = "0.15.2";

  src = fetchurl {
    url = "https://github.com/phar-io/phive/releases/download/${version}/phive-${version}.phar";
    sha256 = "K7B2dT7F1nL14vlql6D+fo6ewkpDnu0A/SnvlCx5Bfk=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -D $src $out/libexec/phive/phive.phar
    makeWrapper ${php}/bin/php $out/bin/phive \
      --add-flags "$out/libexec/phive/phive.phar"
    runHook postInstall
  '';

  meta = with lib; {
    changelog = "https://github.com/phar-io/phive/releases/tag/${version}";
    description = "The Phar Installation and Verification Environment (PHIVE)";
    homepage = "https://github.com/phar-io/phive";
    license = licenses.bsd3;
    maintainers = with maintainers; teams.php.members;
  };
}
