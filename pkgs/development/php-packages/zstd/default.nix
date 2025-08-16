{
  buildPecl,
  lib,
  zstd,
  pkg-config,
  fetchFromGitHub,
}:

let
  version = "0.15.0";
in
buildPecl {
  inherit version;
  pname = "zstd";

  src = fetchFromGitHub {
    owner = "kjdev";
    repo = "php-ext-zstd";
    rev = version;
    hash = "sha256-7Ok0Ej5U7N77Y/vXpgIp1diVSFgB9wXXGDQsKmvGxY8=";
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
