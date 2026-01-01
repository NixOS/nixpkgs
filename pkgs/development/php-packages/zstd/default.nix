{
  buildPecl,
  lib,
  zstd,
  pkg-config,
  fetchFromGitHub,
}:

let
  version = "0.15.2";
in
buildPecl {
  inherit version;
  pname = "zstd";

  src = fetchFromGitHub {
    owner = "kjdev";
    repo = "php-ext-zstd";
    rev = version;
    hash = "sha256-NGbrbvW2kNhgj3nqqjGLqowcp9EKqYffR1DOBIzdXeA=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ zstd ];

  configureFlags = [ "--with-libzstd" ];

<<<<<<< HEAD
  meta = {
    description = "Zstd Extension for PHP";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Zstd Extension for PHP";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://github.com/kjdev/php-ext-zstd";
    maintainers = [ ];
  };
}
