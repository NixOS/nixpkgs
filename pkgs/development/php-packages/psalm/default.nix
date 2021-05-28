{ mkDerivation, fetchurl, pkgs, lib, php }:
let
  pname = "psalm";
  version = "3.11.2";
in
mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/vimeo/psalm/releases/download/${version}/psalm.phar";
    sha256 = "1ani0907whqy2ycr01sjlvrmwps4dg5igim8z1qyv8grhwvw6gb0";
  };

  phases = [ "installPhase" ];
  nativeBuildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    install -D $src $out/libexec/psalm/psalm.phar
    makeWrapper ${php}/bin/php $out/bin/psalm \
      --add-flags "$out/libexec/psalm/psalm.phar"
  '';

  meta = with pkgs.lib; {
    description = "A static analysis tool for finding errors in PHP applications";
    license = licenses.mit;
    homepage = "https://github.com/vimeo/psalm";
    maintainers = teams.php.members;
  };
}
