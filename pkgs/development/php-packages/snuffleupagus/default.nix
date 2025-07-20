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
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "jvoisin";
    repo = "snuffleupagus";
    rev = "v${version}";
    hash = "sha256-W+EQXjvmDHih5YW/SjRcEdUELePUPKrNWB8vW9dLK/g=";
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
