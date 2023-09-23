{ lib, buildNimPackage, fetchFromGitHub }:

buildNimPackage (final: prev: {
  pname = "nimsimd";
  version = "1.2.5";
  src = fetchFromGitHub {
    owner = "guzba";
    repo = "nimsimd";
    rev = final.version;
    hash = "sha256-EYLzpzmNUwEOEndAwnUXCqpIUMmpinpiZq+P6zO0Kk8=";
  };
  meta = final.src.meta // {
    description = "Pleasant Nim bindings for SIMD instruction sets";
    homepage = "https://github.com/guzba/nimsimd";
    license = [ lib.licenses.mit ];
    maintainers = with lib.maintainers; [ ehmry ];
  };
})
