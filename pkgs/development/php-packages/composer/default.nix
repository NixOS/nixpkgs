{ mkDerivation, fetchurl, makeWrapper, unzip, lib, php }:
let
  pname = "composer";
  version = "2.1.0";
in
mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://getcomposer.org/download/${version}/composer.phar";
    sha256 = "0vp1pnf2zykszhyv36gl4j3013z4fqv9yqj9llvbvmmm9ml8z3ig";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -D $src $out/libexec/composer/composer.phar
    makeWrapper ${php}/bin/php $out/bin/composer \
      --add-flags "$out/libexec/composer/composer.phar" \
      --prefix PATH : ${lib.makeBinPath [ unzip ]}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Dependency Manager for PHP";
    license = licenses.mit;
    homepage = "https://getcomposer.org/";
    maintainers = with maintainers; [ offline ] ++ teams.php.members;
  };
}
