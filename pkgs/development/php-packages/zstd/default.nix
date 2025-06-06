{
  buildPecl,
  lib,
  zstd,
  pkg-config,
  fetchFromGitHub,
}:

let
  version = "0.13.3";
in
buildPecl {
  inherit version;
  pname = "zstd";

  src = fetchFromGitHub {
    owner = "kjdev";
    repo = "php-ext-zstd";
    rev = version;
    hash = "sha256-jEuL93ScF0/FlfUvib6uZafOkIe0+VkWV/frpSjTkvY=";
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
