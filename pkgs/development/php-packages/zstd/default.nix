{
  buildPecl,
  lib,
  zstd,
  pkg-config,
  fetchFromGitHub,
}:

buildPecl (finalAttrs: {
  pname = "zstd";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "kjdev";
    repo = "php-ext-zstd";
    tag = finalAttrs.version;
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
})
