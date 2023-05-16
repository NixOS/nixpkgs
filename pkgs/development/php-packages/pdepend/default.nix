{ stdenv, fetchurl, makeWrapper, lib, php }:

let
  pname = "pdepend";
<<<<<<< HEAD
  version = "2.14.0";
=======
  version = "2.13.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/pdepend/pdepend/releases/download/${version}/pdepend.phar";
<<<<<<< HEAD
    sha256 = "sha256-t6Yf+z/8O/tZuYoLAZo2G5bORh8XPeEMdK57dWjHsmk=";
=======
    sha256 = "sha256-cd76PoHzAqsRxQzvklyEIsNO+4jByK8Mwx1aNu8rnnk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
