{ mkDerivation, fetchurl, makeWrapper, lib, php }:

let
  pname = "phpmd";
  version = "2.15.0";
in
mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/phpmd/phpmd/releases/download/${version}/phpmd.phar";
    sha256 = "sha256-aijvVd4MdTsHDR0VgLsIoNFGAW+J8O3c72CsT8EINUQ=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -D $src $out/libexec/phpmd/phpmd.phar
    makeWrapper ${php}/bin/php $out/bin/phpmd \
      --add-flags "$out/libexec/phpmd/phpmd.phar"
    runHook postInstall
  '';

  meta = with lib; {
    changelog = "https://github.com/phpmd/phpmd/releases/tag/${version}";
    description = "PHP code quality analyzer";
    license = licenses.bsd3;
    homepage = "https://phpmd.org/";
    maintainers = teams.php.members;
  };
}
