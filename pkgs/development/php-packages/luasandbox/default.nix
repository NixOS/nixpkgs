{
  lib,
  buildPecl,
  fetchFromGitHub,
  pkg-config,
  lua51Packages,
}:

buildPecl rec {
  pname = "luasandbox";
<<<<<<< HEAD
  version = "4.1.3";
=======
  version = "4.1.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "wikimedia";
    repo = "mediawiki-php-luasandbox";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-YQ7mxrAjtpYCThy0UPHlB0bkf86qpKqXxH4XV0hB+YU=";
=======
    hash = "sha256-HWObytoHBvxF9+QC62yJfi6MuHOOXFbSNkhuz5zWPCY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
