{ stdenv, fetchurl, makeWrapper, lib, php }:

let
  pname = "pdepend";
  version = "2.13.0";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/pdepend/pdepend/releases/download/${version}/pdepend.phar";
    sha256 = "sha256-cd76PoHzAqsRxQzvklyEIsNO+4jByK8Mwx1aNu8rnnk=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -D $src $out/libexec/pdepend/pdepend.phar
    makeWrapper ${php}/bin/php $out/bin/pdepend \
      --add-flags "$out/libexec/pdepend/pdepend.phar"
    runHook postInstall
  '';

  meta = with lib; {
    description = "An adaptation of JDepend for PHP";
    homepage = "https://github.com/pdepend/pdepend";
    license = licenses.bsd3;
    longDescription = "
      PHP Depend is an adaptation of the established Java
      development tool JDepend. This tool shows you the quality
      of your design in terms of extensibility, reusability and
      maintainability.
    ";
    maintainers = teams.php.members;
    platforms = platforms.all;
  };
}
