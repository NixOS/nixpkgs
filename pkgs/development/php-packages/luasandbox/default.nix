{
  lib,
  buildPecl,
  fetchFromGitHub,
  pkg-config,
  lua51Packages,
}:

buildPecl rec {
  pname = "luasandbox";
  version = "4.1.2";

  src = fetchFromGitHub {
    owner = "wikimedia";
    repo = "mediawiki-php-luasandbox";
    tag = version;
    hash = "sha256-HWObytoHBvxF9+QC62yJfi6MuHOOXFbSNkhuz5zWPCY=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ lua51Packages.lua ];

  meta = {
    description = "Extension for PHP 7 and PHP 8 to allow safely running untrusted Lua 5.1 code from within PHP";
    license = lib.licenses.mit;
    homepage = "https://www.mediawiki.org/wiki/LuaSandbox";
    maintainers = with lib.maintainers; [ georgyo ];
    platforms = lib.platforms.linux;
  };
}
