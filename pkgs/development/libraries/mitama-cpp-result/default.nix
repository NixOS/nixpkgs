{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mitama-cpp-result";
  version = "9.3.0";

  src = fetchFromGitHub {
    owner = "LoliGothick";
    repo = "mitama-cpp-result";
    rev = "v${finalAttrs.version}";
    hash = "sha256-CWYVPpmPIZZTsqXKh+Ft3SlQ4C9yjUof1mJ8Acn5kmM=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    homepage = "https://github.com/LoliGothick/mitama-cpp-result";
    description = "Library that provides `result<T, E>` and `maybe<T>` and monadic functions for them";
    longDescription = ''
      mitama-cpp-result is the C++17 libraries for error handling without exceptions.

      mitama-cpp-result provides `result<T, E>`, `maybe<T>`, and associated monadic functions
      (like Result and Option in Programming Language Rust).
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
})
# TODO [ ken-matsui ]: tests
