{
  lib,
  stdenv,
  fetchFromGitHub,
  nixosTests,
  which,
  pcre2,
  withPython3 ? true,
  python3,
  ncurses,
  withPHP81 ? true,
  php81,
  withPHP82 ? false,
  php82,
  withPerl ? true,
  perl,
  withRuby_3_1 ? true,
  ruby_3_1,
  withRuby_3_2 ? false,
  ruby_3_2,
  withSSL ? true,
  openssl ? null,
  withIPv6 ? true,
  withDebug ? false,
}:

let
  phpConfig = {
    embedSupport = true;
    apxs2Support = false;
    systemdSupport = false;
    phpdbgSupport = false;
    cgiSupport = false;
    fpmSupport = false;
  };

  php81-unit = php81.override phpConfig;
  php82-unit = php82.override phpConfig;

  inherit (lib) optional optionals optionalString;
in
stdenv.mkDerivation rec {
  version = "1.35.0";
  pname = "unit";

  src = fetchFromGitHub {
    owner = "nginx";
    repo = "unit";
    rev = version;
    sha256 = "sha256-0cMtU7wmy8GFKqxS8fXPIrMljYXBHzoxrUJCOJSzLMA=";
  };

  nativeBuildInputs = [ which ];

  buildInputs = [
    pcre2.dev
  ]
  ++ optionals withPython3 [
    python3
    ncurses
  ]
  ++ optional withPHP81 php81-unit
  ++ optional withPHP82 php82-unit
  ++ optional withPerl perl
  ++ optional withRuby_3_1 ruby_3_1
  ++ optional withRuby_3_2 ruby_3_2
  ++ optional withSSL openssl;

  configureFlags = [
    "--control=unix:/run/unit/control.unit.sock"
    "--pid=/run/unit/unit.pid"
    "--user=unit"
    "--group=unit"
  ]
  ++ optional withSSL "--openssl"
  ++ optional (!withIPv6) "--no-ipv6"
  ++ optional withDebug "--debug";

  # Optionally add the PHP derivations used so they can be addressed in the configs
  usedPhp81 = optionals withPHP81 php81-unit;

  postConfigure = ''
    ${optionalString withPython3 "./configure python --module=python3  --config=python3-config  --lib-path=${python3}/lib"}
    ${optionalString withPHP81 "./configure php    --module=php81    --config=${php81-unit.unwrapped.dev}/bin/php-config --lib-path=${php81-unit}/lib"}
    ${optionalString withPHP82 "./configure php    --module=php82    --config=${php82-unit.unwrapped.dev}/bin/php-config --lib-path=${php82-unit}/lib"}
    ${optionalString withPerl "./configure perl   --module=perl     --perl=${perl}/bin/perl"}
    ${optionalString withRuby_3_1 "./configure ruby   --module=ruby31   --ruby=${ruby_3_1}/bin/ruby"}
    ${optionalString withRuby_3_2 "./configure ruby   --module=ruby32   --ruby=${ruby_3_2}/bin/ruby"}
  '';

  passthru.tests = {
    unit-perl = nixosTests.unit-perl;
    unit-php = nixosTests.unit-php;
  };

  meta = with lib; {
    description = "Dynamic web and application server, designed to run applications in multiple languages";
    mainProgram = "unitd";
    homepage = "https://unit.nginx.org/";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ izorkin ];
  };
}
