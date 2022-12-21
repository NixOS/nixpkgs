{ mkDerivation, fetchurl, makeWrapper, installShellFiles, lib, php }:

mkDerivation rec {
  pname = "deployer";
  version = "7.0.2";

  src = fetchurl {
    url = "https://github.com/deployphp/deployer/releases/download/v${version}/deployer.phar";
    sha256 = "DdPTpKrEsnM4NZhD/J9Pl0sGJ2woVLQbb9VLB4ZHOTY=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -D $src $out/libexec/deployer/deployer.phar
    makeWrapper ${php}/bin/php $out/bin/dep --add-flags "$out/libexec/deployer/deployer.phar"

    # fish support currently broken: https://github.com/deployphp/deployer/issues/2527
    installShellCompletion --cmd dep \
      --bash <($out/bin/dep autocomplete --install) \
      --zsh <($out/bin/dep autocomplete --install)
    runHook postInstall
  '';

  meta = with lib; {
    description = "A deployment tool for PHP";
    license = licenses.mit;
    homepage = "https://deployer.org/";
    mainProgram = "dep";
    maintainers = with maintainers; teams.php.members;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
