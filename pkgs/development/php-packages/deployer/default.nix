{ mkDerivation, fetchurl, makeWrapper, installShellFiles, lib, php }:

mkDerivation rec {
  pname = "deployer";
  version = "7.3.3";

  src = fetchurl {
    url = "https://github.com/deployphp/deployer/releases/download/v${version}/${pname}.phar";
    hash = "sha256-6F9o7u+BjXsJv1CUawBsCgltIwaeJodVluJjEKbQanY=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -D $src $out/libexec/deployer/deployer.phar
    makeWrapper ${php}/bin/php $out/bin/dep --add-flags "$out/libexec/deployer/deployer.phar"

    # fish support currently broken: https://github.com/deployphp/deployer/issues/2527
    installShellCompletion --cmd dep \
      --bash <($out/bin/dep completion) \
      --zsh <($out/bin/dep completion)
    runHook postInstall
  '';

  meta = with lib; {
    changelog = "https://github.com/deployphp/deployer/releases/tag/v${version}";
    description = "A deployment tool for PHP";
    homepage = "https://deployer.org/";
    license = licenses.mit;
    mainProgram = "dep";
    maintainers = with maintainers; teams.php.members;
  };
}
