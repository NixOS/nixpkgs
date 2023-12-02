{ stdenv
, buildPecl
, lib
, libiconv
, php
, fetchFromGitHub
, pcre2
, darwin
}:

buildPecl rec {
  pname = "snuffleupagus";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "jvoisin";
    repo = "snuffleupagus";
    rev = "v${version}";
    hash = "sha256-1a4PYJ/j9BsoeF5V/KKGu7rqsL3YMo/FbaCBfNc4bfw=";
  };

  buildInputs = [
    pcre2
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.CoreFoundation
    darwin.apple_sdk_11_0.Libsystem
    libiconv
  ];

  internalDeps = with php.extensions; [
    session
  ];

  sourceRoot = "${src.name}/src";

  configureFlags = [
    "--enable-snuffleupagus"
  ];

  postPhpize = ''
    ./configure --enable-snuffleupagus
  '';

  meta = {
    description = "Security module for php7 and php8 - Killing bugclasses and virtual-patching the rest!";
    homepage = "https://github.com/jvoisin/snuffleupagus";
    license = lib.licenses.lgpl3Only;
    maintainers = lib.teams.php.members ++ [ lib.maintainers.zupo ];
  };
}
