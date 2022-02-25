{ stdenv, fetchurl, makeWrapper, unzip, lib, php }:

stdenv.mkDerivation rec {
  name = "terminus-cli";
  version = "3.0.6";

  src = fetchurl {
    url = "https://github.com/pantheon-systems/terminus/releases/download/${version}/terminus.phar";
    sha256 = "11abwsdfp66dqx3lqk6jw82xq3cvsrjpz336m90kmnq487fqrhhx";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -D $src $out/libexec/terminus.phar
    makeWrapper ${php}/bin/php $out/bin/terminus \
      --add-flags "$out/libexec/terminus.phar" \
      --prefix PATH : ${lib.makeBinPath [ unzip ]}
    runHook postInstall
  '';

  meta = with lib; {
    description = "A standalone utility for performing operations on the Pantheon Platform";
    homepage = "https://pantheon.io/docs/terminus";
    changelog = "https://github.com/pantheon-systems/terminus/blob/3.x/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ asimpson ];
  };
}
