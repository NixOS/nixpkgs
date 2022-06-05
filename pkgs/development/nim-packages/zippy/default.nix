{ lib, buildNimPackage, fetchFromGitHub, unzip }:

buildNimPackage rec {
  pname = "zippy";
  version = "0.9.11";

  nativeBuildInputs = [ unzip ];

  src = fetchFromGitHub {
    owner = "guzba";
    repo = pname;
    rev = version;
    hash = "sha256-niugXeePxdy58bb+o0MIwH6vuhjW7kBAjqQT+mRpXt8=";
  };

  doCheck = true;

  meta = with lib;
    src.meta // {
      description = "Pure Nim implementation of deflate, zlib, gzip and zip";
      license = [ licenses.mit ];
      maintainers = [ maintainers.ehmry ];
    };
}
