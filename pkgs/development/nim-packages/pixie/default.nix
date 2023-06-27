{ lib, buildNimPackage, fetchFromGitHub, bumpy, chroma, flatty, nimsimd, vmath
, zippy }:

buildNimPackage rec {
  pname = "pixie";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "treeform";
    repo = pname;
    rev = version;
    hash = "sha256-rF72ybfsipBHgQmH0e6DBn1e7WWY6dGn9yp1qvLIS3A=";
  };

  propagatedBuildInputs = [ bumpy chroma flatty nimsimd vmath zippy ];


  meta = with lib;
    src.meta // {
      description = "Full-featured 2d graphics library for Nim";
      license = [ licenses.mit ];
      maintainers = [ maintainers.ehmry ];
    };
}
