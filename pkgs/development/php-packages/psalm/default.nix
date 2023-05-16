{ mkDerivation, fetchurl, makeWrapper, lib, php }:

let
  pname = "psalm";
<<<<<<< HEAD
  version = "5.15.0";
=======
  version = "5.9.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in
mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/vimeo/psalm/releases/download/${version}/psalm.phar";
<<<<<<< HEAD
    sha256 = "sha256-eAvogKsnvXMNUZHh44RPHpd0iMqEY9fzqJvXPT7SE1A=";
=======
    sha256 = "sha256-56vLT/t+3f5ZyH1pFmgy4vtSMQcDYLQZIF/iIkwd2vM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    changelog = "https://github.com/vimeo/psalm/releases/tag/${version}";
    description = "A static analysis tool for finding errors in PHP applications";
    license = licenses.mit;
    homepage = "https://github.com/vimeo/psalm";
    maintainers = teams.php.members;
  };
}
