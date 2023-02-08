{ buildPecl
, lib
, php
, fetchFromGitHub
, pcre2
, fetchpatch
}:

buildPecl rec {
  pname = "snuffleupagus";
  version = "0.9.0";
  src = fetchFromGitHub {
    owner = "jvoisin";
    repo = pname;
    rev = "v${version}";
    sha256 = "1a4PYJ/j9BsoeF5V/KKGu7rqsL3YMo/FbaCBfNc4bfw=";
  };

  buildInputs = [
    pcre2
  ];

  internalDeps = with php.extensions; [
    session
  ];

  patches = [
    (fetchpatch {
      url = "https://github.com/jvoisin/snuffleupagus/commit/3c528d9d03cec872382a6f400b5701a8fbfd59b4.patch";
      sha256 = "0lnj4xcl867f477mha697d1py1nwxhl18dvvg40qgflpdbywlzns";
      stripLen = 1;
    })
  ];

  sourceRoot = "source/src";

  configureFlags = [
    "--enable-snuffleupagus"
  ];

  postPhpize = ''
    ./configure --enable-snuffleupagus
  '';

  meta = with lib; {
    description = "Security module for php7 and php8 - Killing bugclasses and virtual-patching the rest!";
    license = licenses.lgpl3Only;
    homepage = "https://github.com/jvoisin/snuffleupagus";
    maintainers = teams.php.members ++ [ maintainers.zupo ];
  };
}
