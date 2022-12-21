{ mkDerivation, fetchFromGitHub, makeWrapper, lib, php }:
mkDerivation rec {
  pname = "grumphp";
  version = "1.15.0";

  src = fetchFromGitHub {
    repo = "grumphp-shim";
    owner = "phpro";
    rev = "v${version}";
    sha256 = "EEbFsOIL/weafaQ+racJaKc4bzsWZKuMNmZ273jeRto=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -D $src/grumphp.phar $out/libexec/${pname}/grumphp.phar
    makeWrapper ${php}/bin/php $out/bin/grumphp \
      --add-flags "$out/libexec/${pname}/grumphp.phar"
    runHook postInstall
  '';

  meta = with lib; {
    description = "A PHP code-quality tool";
    homepage = "https://github.com/phpro/grumphp";
    license = licenses.mit;
    maintainers = teams.php.members;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
