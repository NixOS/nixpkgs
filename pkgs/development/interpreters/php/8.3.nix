{ callPackage, ... }@_args:

let
  base = callPackage ./generic.nix (
    _args
    // {
<<<<<<< HEAD
      version = "8.3.29";
      hash = "sha256-xzNyEuZVMl1JnqgQj6dvad3eL/98sPrTaqY+7VQMuKU=";
=======
      version = "8.3.28";
      hash = "sha256-1bOF7jUexGPIXUfutTtRFW80g+rz/0OnrVCAwrbUxVc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    }
  );
in
base.withExtensions (
  { all, ... }:
  with all;
  [
    bcmath
    calendar
    curl
    ctype
    dom
    exif
    fileinfo
    filter
    ftp
    gd
    gettext
    gmp
    iconv
    imap
    intl
    ldap
    mbstring
    mysqli
    mysqlnd
    opcache
    openssl
    pcntl
    pdo
    pdo_mysql
    pdo_odbc
    pdo_pgsql
    pdo_sqlite
    pgsql
    posix
    readline
    session
    simplexml
    sockets
    soap
    sodium
    sysvsem
    sqlite3
    tokenizer
    xmlreader
    xmlwriter
    zip
    zlib
  ]
)
