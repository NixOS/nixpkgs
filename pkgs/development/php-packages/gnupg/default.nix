{
  buildPecl,
  lib,
  gpgme,
  file,
  gnupg,
  php,
  fetchFromGitHub,
}:

let
  version = "1.5.4";
in
buildPecl {
  inherit version;
  pname = "gnupg";

  src = fetchFromGitHub {
    owner = "php-gnupg";
    repo = "php-gnupg";
    rev = "gnupg-${version}";
    fetchSubmodules = true;
    hash = "sha256-g9w0v9qc/Q5qjB9/ekZyheQ1ClIEqMEoBc32nGWhXYA=";
  };

  buildInputs = [ gpgme ];
  nativeCheckInputs = [ gnupg ];

  postPhpize = ''
    substituteInPlace configure \
      --replace-fail '/usr/bin/file' '${file}/bin/file' \
      --replace-fail 'SEARCH_PATH="/usr/local /usr /opt /opt/homebrew"' 'SEARCH_PATH="${gpgme.dev}"'
  '';

  postConfigure = ''
    substituteInPlace Makefile \
      --replace-fail 'run-tests.php' 'run-tests.php -q --offline'
    substituteInPlace tests/gnupg_res_init_file_name.phpt \
      --replace-fail '/usr/bin/gpg' '${gnupg}/bin/gpg' \
      --replace-fail 'string(12)' 'string(${toString (lib.stringLength "${gnupg}/bin/gpg")})'
    substituteInPlace tests/gnupg_oo_init_file_name.phpt \
      --replace-fail '/usr/bin/gpg' '${gnupg}/bin/gpg' \
      --replace-fail 'string(12)' 'string(${toString (lib.stringLength "${gnupg}/bin/gpg")})'
  '';

  patches = [
    # https://github.com/php-gnupg/php-gnupg/issues/62
    ./missing-new-line-test.patch
  ];

  doCheck = true;

  meta = {
    changelog = "https://github.com/php-gnupg/php-gnupg/releases/tag/gnupg-${version}";
    broken = lib.versionOlder php.version "8.1"; # Broken on PHP older than 8.1.
    description = "PHP wrapper for GpgME library that provides access to GnuPG";
    license = lib.licenses.bsd3;
    homepage = "https://pecl.php.net/package/gnupg";
    maintainers = with lib.maintainers; [ taikx4 ];
    teams = [ lib.teams.php ];
  };
}
