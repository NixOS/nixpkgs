{ lib, buildNimPackage, fetchFromGitHub, htslib }:

buildNimPackage (final: prev: {
  pname = "hts";
  version = "0.3.23";
  src = fetchFromGitHub {
    owner = "brentp";
    repo = "hts-nim";
    rev = "v${final.version}";
    hash = "sha256-o27yOtzW4hk8dpicqjW4D8zxqXHdxcz+e84PyK+yBq8=";
  };
  propagatedBuildInputs = [ htslib ];
  nimFlags = [ "--mm:refc" ];
  doCheck = false;
  meta = final.src.meta // {
    description = "Nim wrapper for htslib for parsing genomics data files";
    homepage = "https://brentp.github.io/hts-nim/";
    license = [ lib.licenses.mit ];
    maintainers = with lib.maintainers; [ ehmry ];
  };
})
