{ buildPecl, lib, gpgme, file, gnupg, php, fetchFromGitHub }:

let
  version = "1.5.1";
in buildPecl {
  inherit version;
  pname = "gnupg";

  src = fetchFromGitHub {
    owner = "php-gnupg";
    repo = "php-gnupg";
    rev = "gnupg-${version}";
    fetchSubmodules = true;
    sha256 = "sha256-kEc0883sYgmAf1mkH0zRjHzUASnZgQvdYE6VzT5X2RI=";
  };

  buildInputs = [ gpgme ];
  checkInputs = [ gnupg ];

  postPhpize = ''
    substituteInPlace configure \
      --replace '/usr/bin/file' '${file}/bin/file' \
      --replace 'SEARCH_PATH="/usr/local /usr /opt"' 'SEARCH_PATH="${gpgme.dev}"'
  '';

  postConfigure = with lib; ''
    substituteInPlace Makefile \
      --replace 'run-tests.php' 'run-tests.php -q --offline'
    substituteInPlace tests/gnupg_res_init_file_name.phpt \
      --replace '/usr/bin/gpg' '${gnupg}/bin/gpg' \
      --replace 'string(12)' 'string(${toString (stringLength "${gnupg}/bin/gpg")})'
    substituteInPlace tests/gnupg_oo_init_file_name.phpt \
      --replace '/usr/bin/gpg' '${gnupg}/bin/gpg' \
      --replace 'string(12)' 'string(${toString (stringLength "${gnupg}/bin/gpg")})'
  '';

  doCheck = true;

  meta = with lib; {
    changelog = "https://github.com/php-gnupg/php-gnupg/releases/tag/gnupg-${version}";
    broken = lib.versionOlder php.version "8.1"; # Broken on PHP older than 8.1.
    description = "PHP wrapper for GpgME library that provides access to GnuPG";
    license = licenses.bsd3;
    homepage = "https://pecl.php.net/package/gnupg";
    maintainers = with maintainers; [ taikx4 ] ++ teams.php.members;
  };
}
