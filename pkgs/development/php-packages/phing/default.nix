{ mkDerivation, fetchurl, makeWrapper, lib, php }:
let
  pname = "phing";
  version = "2.17.2";
in
mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://www.phing.info/get/phing-${version}.phar";
    sha256 = "sha256-KDqJdHIqgtar6ofNG4ENRlpRg9XYFeL5YS7Rclh1+PQ=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -D $src $out/libexec/phing/phing.phar
    makeWrapper ${php}/bin/php $out/bin/phing \
      --add-flags "$out/libexec/phing/phing.phar"
    runHook postInstall
  '';

  meta = with lib; {
    description = "PHing Is Not GNU make; it's a PHP project build system or build tool based on Apache Ant";
    license = licenses.lgpl3;
    homepage = "https://github.com/phingofficial/phing";
    maintainers = with maintainers; teams.php.members;
  };
}
