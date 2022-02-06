{ mkDerivation, fetchurl, makeWrapper, lib, php }:

mkDerivation rec {
  pname = "box";
  version = "3.15.0";

  src = fetchurl {
    url = "https://github.com/box-project/box/releases/download/${version}/box.phar";
    sha256 = "sha256-Etngn/WQMIwrUXJB+tXB/hF0gKkPKSbzQ6HgsZRJWzI=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -D $src $out/libexec/box/box.phar
    makeWrapper ${php}/bin/php $out/bin/box \
      --add-flags "-d phar.readonly=0 $out/libexec/box/box.phar"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Fast, zero config application bundler with PHARs";
    homepage = "https://github.com/box-project/box";
    license = licenses.mit;
    maintainers = with maintainers; [ jtojnar ] ++ teams.php.members;
  };
}
