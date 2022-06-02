{ mkDerivation, fetchurl, makeWrapper, lib, php }:

mkDerivation rec {
  pname = "phive";
  version = "0.15.0";

  src = fetchurl {
    url = "https://github.com/phar-io/phive/releases/download/${version}/phive-${version}.phar";
    sha256 = "sha256-crMr8d5nsVt7+zQ5xPeph/JXmTEn6jJFVtp3mOgylB4=";
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
    description = "The Phar Installation and Verification Environment (PHIVE)";
    homepage = "https://github.com/phar-io/phive";
    license = licenses.bsd3;
    maintainers = with maintainers; teams.php.members;
  };
}
