{
  buildPecl,
  lib,
  zstd,
  pkg-config,
  fetchFromGitHub,
}:

let
  version = "0.18.0";
in
buildPecl {
  inherit version;
  pname = "zstd";

  src = fetchFromGitHub {
    owner = "kjdev";
    repo = "php-ext-zstd";
    rev = version;
    hash = "sha256-3uTuAfHSeLKMbaRkUMUo3WWA4oGT7nXqXWlB1DUfzao=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ zstd ];

  configureFlags = [ "--with-libzstd" ];

  meta = {
    description = "Zstd Extension for PHP";
    license = lib.licenses.mit;
    homepage = "https://github.com/kjdev/php-ext-zstd";
    maintainers = [ ];
  };
}
