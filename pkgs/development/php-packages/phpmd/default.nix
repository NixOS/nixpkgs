{ mkDerivation, fetchurl, makeWrapper, lib, php }:
let
  pname = "phpmd";
  version = "2.8.2";
in
mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/phpmd/phpmd/releases/download/${version}/phpmd.phar";
    sha256 = "1i8qgzxniw5d8zjpypalm384y7qfczapfq70xmg129laq6xiqlqb";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -D $src $out/libexec/phpmd/phpmd.phar
    makeWrapper ${php}/bin/php $out/bin/phpmd \
      --add-flags "$out/libexec/phpmd/phpmd.phar"
    runHook postInstall
  '';

  meta = with lib; {
    description = "PHP code quality analyzer";
    license = licenses.bsd3;
    homepage = "https://phpmd.org/";
    maintainers = teams.php.members;
    broken = versionOlder php.version "7.4";
  };
}
