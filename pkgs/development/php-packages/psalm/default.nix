{ mkDerivation, fetchurl, makeWrapper, lib, php }:

mkDerivation rec {
  pname = "psalm";
  version = "4.22.0";

  src = fetchurl {
    url = "https://github.com/vimeo/psalm/releases/download/${version}/psalm.phar";
    sha256 = "sha256-XuO0DyEMC9+e9FRx8BYa5KdOYc2tQsUfWJ8AygS9z6w=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -D $src $out/libexec/psalm/psalm.phar
    makeWrapper ${php}/bin/php $out/bin/psalm \
      --add-flags "$out/libexec/psalm/psalm.phar"
    runHook postInstall
  '';

  meta = with lib; {
    description = "A static analysis tool for finding errors in PHP applications";
    homepage = "https://github.com/vimeo/psalm";
    license = licenses.mit;
    maintainers = teams.php.members;
  };
}
