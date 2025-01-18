{
  buildPecl,
  lib,
  zstd,
  pkg-config,
  fetchFromGitHub,
}:

let
  version = "0.14.0";
in
buildPecl {
  inherit version;
  pname = "zstd";

  src = fetchFromGitHub {
    owner = "kjdev";
    repo = "php-ext-zstd";
    rev = version;
    hash = "sha256-XB8GatrL2gQbTiZp6eJCFu8yRAOcrQbcJCaKol3or8Q=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ zstd ];

  configureFlags = [ "--with-libzstd" ];

  meta = with lib; {
    description = "Zstd Extension for PHP";
    license = licenses.mit;
    homepage = "https://github.com/kjdev/php-ext-zstd";
    maintainers = with lib.maintainers; [ shyim ];
  };
}
