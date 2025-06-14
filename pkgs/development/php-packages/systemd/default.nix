{
  fetchFromGitHub,
  buildPecl,
  fetchpatch,
  systemd,
  lib,
}:

buildPecl {

  pname = "systemd";
  version = "0.1.2-5-g22cf92a";

  src = fetchFromGitHub {
    owner = "systemd";
    repo = "php-systemd";
    rev = "22cf92a6b54ef4c5c13c301fc97d7a7b1615ee62";
    hash = "sha256-UhpE9QXChqKLBqutpQ2Y6neo/ULlJGNojf9DCYJfQMU=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/systemd/php-systemd/pull/8.diff";
      hash = "sha256-g73qI6gKpj5keaGIXdujcii8IWSSBUK9h8gUUVNcKVc=";
    })
  ];

  buildInputs = [ systemd.dev ];

  configureFlags = [ "--with-systemd=${systemd.dev}" ];

  installPhase = ''
    runHook preInstall
    install -D .libs/systemd.so $out/lib/php/extensions/systemd.so
    runHook postInstall
  '';

  meta = {
    description = "PHP extension allowing native interaction with systemd and its journal";
    homepage = "https://github.com/systemd/php-systemd";
    license = lib.licenses.mit;
    teams = [ lib.teams.php ];
  };
}
