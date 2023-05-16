<<<<<<< HEAD
{ stdenv
, buildPecl
, lib
, libiconv
, php
, fetchFromGitHub
, pcre2
, darwin
=======
{ buildPecl
, lib
, php
, fetchFromGitHub
, pcre2
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPecl rec {
  pname = "snuffleupagus";
<<<<<<< HEAD
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "jvoisin";
    repo = "snuffleupagus";
    rev = "v${version}";
    hash = "sha256-1a4PYJ/j9BsoeF5V/KKGu7rqsL3YMo/FbaCBfNc4bfw=";
=======
  version = "0.7.0";
  src = fetchFromGitHub {
    owner = "jvoisin";
    repo = pname;
    rev = "v${version}";
    sha256 = "1la6wa9xznc110b7isiy502x71mkvhisq6m8llhczpq4rs4nbcw2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [
    pcre2
<<<<<<< HEAD
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.CoreFoundation
    darwin.apple_sdk_11_0.Libsystem
    libiconv
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  internalDeps = with php.extensions; [
    session
  ];

<<<<<<< HEAD
  sourceRoot = "${src.name}/src";
=======
  patches = [
    (fetchpatch {
      url = "https://github.com/jvoisin/snuffleupagus/commit/3c528d9d03cec872382a6f400b5701a8fbfd59b4.patch";
      sha256 = "0lnj4xcl867f477mha697d1py1nwxhl18dvvg40qgflpdbywlzns";
      stripLen = 1;
    })
  ];

  sourceRoot = "source/src";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  configureFlags = [
    "--enable-snuffleupagus"
  ];

  postPhpize = ''
    ./configure --enable-snuffleupagus
  '';

<<<<<<< HEAD
  meta = {
    description = "Security module for php7 and php8 - Killing bugclasses and virtual-patching the rest!";
    homepage = "https://github.com/jvoisin/snuffleupagus";
    license = lib.licenses.lgpl3Only;
    maintainers = lib.teams.php.members ++ [ lib.maintainers.zupo ];
=======
  meta = with lib; {
    description = "Security module for php7 and php8 - Killing bugclasses and virtual-patching the rest!";
    license = licenses.lgpl3Only;
    homepage = "https://github.com/jvoisin/snuffleupagus";
    maintainers = teams.php.members ++ [ maintainers.zupo ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
