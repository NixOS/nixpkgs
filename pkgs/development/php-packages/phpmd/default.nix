{ mkDerivation, fetchurl, makeWrapper, lib, php }:

let
  pname = "phpmd";
  version = "2.14.1";
in
mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/phpmd/phpmd/releases/download/${version}/phpmd.phar";
    sha256 = "sha256-C5VDs0G21EyUVlldg05cbrSYG4/fk01VKE7Eq/zODu8=";
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
    changelog = "https://github.com/phpmd/phpmd/releases/tag/${version}";
    description = "PHP code quality analyzer";
    license = licenses.bsd3;
    homepage = "https://phpmd.org/";
    maintainers = teams.php.members;
  };
}
