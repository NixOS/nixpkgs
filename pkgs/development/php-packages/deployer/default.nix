{ mkDerivation, fetchurl, makeWrapper, lib, php }:

mkDerivation rec {
  pname = "deployer";
  version = "6.8.0";

  src = fetchurl {
    url = "https://deployer.org/releases/v${version}/${pname}.phar";
    sha256 = "09mxwfa7yszsiljbkxpsd4sghqngl08cn18v4g1fbsxp3ib3kxi5";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    install -D $src $out/libexec/deployer/deployer.phar
    makeWrapper ${php}/bin/php $out/bin/dep --add-flags "$out/libexec/deployer/deployer.phar"
  '';

  meta = with lib; {
    description = "A deployment tool for PHP";
    license = licenses.mit;
    homepage = "https://deployer.org/";
    maintainers = with maintainers; teams.php.members;
  };
}
