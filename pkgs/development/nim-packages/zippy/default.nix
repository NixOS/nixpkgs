{ lib, buildNimPackage, fetchFromGitHub, unzip }:

buildNimPackage rec {
  pname = "zippy";
  version = "0.7.3";

  nativeBuildInputs = [ unzip ];

  src = fetchFromGitHub {
    owner = "guzba";
    repo = pname;
    rev = version;
    hash = "sha256-w64ENRyP3mNTtESSt7CDDxUkjYSfziNVVedkO4HIuJ8=";
  };

  doCheck = true;

  meta = with lib;
    src.meta // {
      description = "Pure Nim implementation of deflate, zlib, gzip and zip";
      license = [ licenses.mit ];
      maintainers = [ maintainers.ehmry ];
    };
}
