{ lib, buildNimPackage, fetchFromGitHub, unzip }:

buildNimPackage rec {
  pname = "zippy";
  version = "0.9.9";

  nativeBuildInputs = [ unzip ];

  src = fetchFromGitHub {
    owner = "guzba";
    repo = pname;
    rev = version;
    hash = "sha256-IrZzDPaXy+8KfDn5Mk6WoEx1XPVsRrhCWt53yxtpekY=";
  };

  doCheck = true;

  meta = with lib;
    src.meta // {
      description = "Pure Nim implementation of deflate, zlib, gzip and zip";
      license = [ licenses.mit ];
      maintainers = [ maintainers.ehmry ];
    };
}
