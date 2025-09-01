{
  buildPecl,
  fetchFromGitHub,
  fetchpatch,
  lib,
  php,
  runCommand,
  systemd,
}:

buildPecl {
  pname = "systemd";
  version = "0.1.2-unstable-2018-06-11";

  src = fetchFromGitHub {
    owner = "systemd";
    repo = "php-systemd";
    rev = "22cf92a6b54ef4c5c13c301fc97d7a7b1615ee62";
    hash = "sha256-UhpE9QXChqKLBqutpQ2Y6neo/ULlJGNojf9DCYJfQMU=";
  };

  patches = [
    # Add missing arginfo to suppress the warning
    # https://github.com/systemd/php-systemd/issues/9
    (fetchpatch {
      url = "https://github.com/systemd/php-systemd/commit/0f25ec9aab7747e85445a48213020ea6adda3658.diff";
      hash = "sha256-SNRYDRxaeP9LlHxfZOak0OSqZ3AJA+I9Ln0k+yO0DvE=";
    })
    # Define SD_JOURNAL_SUPPRESS_LOCATION so that the php source code location is used, instead of the C one
    # https://github.com/systemd/php-systemd/issues/2
    (fetchpatch {
      url = "https://github.com/systemd/php-systemd/commit/23575461b8cc55fa9c4132a58393b6438c2aff5c.diff";
      hash = "sha256-KBGWdNE7spXpqbeS4c2D5IU3Dz8zGxx4r22FDOA0KzM=";
    })
  ];

  buildInputs = [ systemd.dev ];

  configureFlags = [ "--with-systemd=${systemd.dev}" ];

  # php will exit with a non-zero exit code, if the extension is not loaded
  passthru.tests.smokeTest = runCommand "php-systemd-smoke-test" { } ''
    echo "<?php sd_journal_send('MESSAGE=Hello world.'); ?>" |
      ${lib.getExe (php.withExtensions ({ all, ... }: [ all.systemd ]))}
    echo ok > $out
  '';

  meta = {
    description = "PHP extension allowing native interaction with systemd and its journal";
    homepage = "https://github.com/systemd/php-systemd";
    license = lib.licenses.mit;
    teams = [ lib.teams.php ];
  };
}
