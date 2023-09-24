{ lib
, stdenv
, fetchurl
, makeBinaryWrapper
, installShellFiles
, php
, nix-update-script
, testers
, castor
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "castor";
  version = "0.8.0";


  src = fetchurl {
    url = "https://github.com/jolicode/castor/releases/download/v${finalAttrs.version}/castor.linux-amd64.phar";
    hash = "sha256-0lnn4mS1/DgUoRoMFvCjwQ0j9CX9XWlskbtX9roFCfc=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeBinaryWrapper installShellFiles ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -D $src $out/libexec/castor/castor.phar
    makeWrapper ${php}/bin/php $out/bin/castor \
      --add-flags "$out/libexec/castor/castor.phar"
    runHook postInstall
  '';

  # castor requires to be initialized to generate completion files
  postInstall = ''
    echo "yes" | ${php}/bin/php $src
    installShellCompletion --cmd castor \
      --bash <($out/bin/castor completion bash) \
      --fish <($out/bin/castor completion fish) \
      --zsh <($out/bin/castor completion zsh)
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      inherit (finalAttrs) version;
      package = castor;
      command = "castor --version";
    };
  };

  meta = with lib; {
    description = "DX oriented task runner and command launcher built with PHP";
    homepage = "https://github.com/jolicode/castor";
    changelog = "https://github.com/jolicode/castor/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ gaelreyrol ];
  };
})
