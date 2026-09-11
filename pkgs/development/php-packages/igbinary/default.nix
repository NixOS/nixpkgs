{
  buildPecl,
  lib,
  php,
}:
buildPecl {
  pname = "igbinary";
  version = "3.2.16";
  sha256 = "sha256-i/JdRlq8eXPZ4smjA5pfjupjWyO8FHcBf/OZn/lYNto=";

  configureFlags = [ "--enable-igbinary" ];
  makeFlags = [ "phpincludedir=$(dev)/include" ];
  outputs = [
    "out"
    "dev"
  ];

  meta = {
    description = "Binary serialization for PHP";
    homepage = "https://github.com/igbinary/igbinary/";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.php ];
    broken = lib.versionAtLeast php.version "8.5";
  };
}
