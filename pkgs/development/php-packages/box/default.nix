{ mkDerivation, fetchurl, makeWrapper, lib, php }:

let
  pname = "box";
  version = "4.3.8";
in
mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/box-project/box/releases/download/${version}/box.phar";
    sha256 = "sha256-g9Y92yTsyXU4NWuQwyB3PRrKJxLRSBO9J77jumXPOxg=";
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
    changelog = "https://github.com/box-project/box/releases/tag/${version}";
    description = "An application for building and managing Phars";
    license = licenses.mit;
    homepage = "https://github.com/box-project/box";
    maintainers = with maintainers; [ ] ++ teams.php.members;
  };
}
