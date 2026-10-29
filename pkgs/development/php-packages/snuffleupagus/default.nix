{
  stdenv,
  buildPecl,
  lib,
  libiconv,
  php,
  fetchFromGitHub,
  pcre2,
}:

buildPecl rec {
  pname = "snuffleupagus";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "jvoisin";
    repo = "snuffleupagus";
    rev = "v${version}";
    hash = "sha256-14Hci2/f1kSV/lCAlFTNrv/WLJxeh+Wyf0QF0+xoedc=";
  };

  buildInputs = [
    pcre2
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  internalDeps = with php.extensions; [ session ];

  sourceRoot = "${src.name}/src";

  configureFlags = [ "--enable-snuffleupagus" ];

  postPhpize = ''
    ./configure --enable-snuffleupagus
  '';

  meta = {
    description = "Security module for php7 and php8 - Killing bugclasses and virtual-patching the rest";
    homepage = "https://github.com/jvoisin/snuffleupagus";
    license = lib.licenses.lgpl3Only;
    maintainers = [ lib.maintainers.zupo ];
    teams = [ lib.teams.php ];
  };
}
