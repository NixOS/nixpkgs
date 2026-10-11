{
  buildPecl,
  fetchFromGitHub,
  fetchpatch,
  lib,
  php,
  libkrb5,
  openssl,
  pam,
  pcre2,
  pkg-config,
  uwimap,
}:

let
  version = "1.0.3";
in
buildPecl {
  inherit version;
  pname = "imap";

  src = fetchFromGitHub {
    owner = "php";
    repo = "pecl-mail-imap";
    rev = version;
    hash = "sha256-eDrznw5OtQXJZa7dR9roUiJyINXFZI5qmS+cyoaGHnk=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    uwimap
    openssl
    pam
    pcre2
    libkrb5
  ];

  configureFlags = [
    "--with-imap=${uwimap}"
    "--with-imap-ssl"
    "--with-kerberos"
  ];

  doCheck = true;

  meta = {
    broken = lib.versionAtLeast php.version "8.6";
    description = "PHP extension for checking the spelling of a word";
    homepage = "https://pecl.php.net/package/imap";
    license = lib.licenses.php301;
    teams = [ lib.teams.php ];
  };
}
