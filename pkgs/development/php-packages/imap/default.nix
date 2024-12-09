{
  buildPecl,
  fetchFromGitHub,
  fetchpatch,
  lib,
  libkrb5,
  openssl,
  pam,
  pcre2,
  pkg-config,
  uwimap,
}:

let
  version = "1.0.2";
in
buildPecl {
  inherit version;
  pname = "imap";

  src = fetchFromGitHub {
    owner = "php";
    repo = "pecl-mail-imap";
    rev = version;
    hash = "sha256-QVeimxm3rfWMvMpSgadhMKd24yPdDGVuhXIOs8668do=";
  };

  patches = [
    # Fix compilation with PHP 8.4.
    (fetchpatch {
      url = "https://github.com/php/pecl-mail-imap/commit/4fc9970a29c205ec328f36edc8c119c158129324.patch";
      hash = "sha256-MxEaEe4YVeP7W5gDSNJb0thwAhxDj/yRr3qvjlJjRL4=";
    })
  ];

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

  meta = with lib; {
    description = "PHP extension for checking the spelling of a word";
    homepage = "https://pecl.php.net/package/imap";
    license = licenses.php301;
    maintainers = teams.php.members;
  };
}
