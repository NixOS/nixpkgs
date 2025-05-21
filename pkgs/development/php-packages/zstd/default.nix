{
  buildPecl,
  lib,
  zstd,
  pkg-config,
  fetchFromGitHub,
}:

let
  version = "0.14.0+pie";
in
buildPecl {
  inherit version;
  pname = "zstd";

  src = fetchFromGitHub {
    owner = "kjdev";
    repo = "php-ext-zstd";
    rev = version;
    hash = "sha256-BfxYPc7Y9VKjm/RiyO+/thpqNJFGMdD5xK07EZMb+E8=";
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
