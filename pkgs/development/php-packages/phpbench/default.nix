{ mkDerivation
, fetchurl
, makeWrapper
, lib
, php
}:

mkDerivation rec {
  pname = "phpbench";
  version = "1.1.3";

  src = fetchurl {
    url = "https://github.com/phpbench/phpbench/releases/download/${version}/phpbench.phar";
    sha256 = "AsC9IORjTv7gryTUHJGcKAwIraxywod6PbDEs30P0h4=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    install -D "$src" "$out/libexec/phpbench/phpbench.phar"
    makeWrapper "${php}/bin/php" "$out/bin/phpbench" \
      --add-flags "$out/libexec/phpbench/phpbench.phar"

    runHook postInstall
  '';

  meta = with lib; {
    description = "PHP Benchmarking framework";
    license = licenses.mit;
    homepage = "https://github.com/phpbench/phpbench";
    maintainers = with maintainers; [ jtojnar ];
  };
}
