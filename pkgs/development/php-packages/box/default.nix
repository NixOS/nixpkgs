{ mkDerivation, fetchurl, makeWrapper, lib, php }:
let
  pname = "box";
  version = "2.7.5";
in
mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/box-project/box2/releases/download/${version}/box-${version}.phar";
    sha256 = "1zmxdadrv0i2l8cz7xb38gnfmfyljpsaz2nnkjzqzksdmncbgd18";
  };

  phases = [ "installPhase" ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    install -D $src $out/libexec/box/box.phar
    makeWrapper ${php}/bin/php $out/bin/box \
      --add-flags "-d phar.readonly=0 $out/libexec/box/box.phar"
  '';

  meta = with lib; {
    description = "An application for building and managing Phars";
    license = licenses.mit;
    homepage = "https://box-project.github.io/box2/";
    maintainers = with maintainers; [ jtojnar ] ++ teams.php.members;
  };
}
