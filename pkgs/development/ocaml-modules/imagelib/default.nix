{ lib, fetchFromGitHub, fetchpatch, buildDunePackage, decompress }:

buildDunePackage rec {
  minimumOCamlVersion = "4.07";
  version = "20191011";
  pname = "imagelib";
  src = fetchFromGitHub {
    owner = "rlepigre";
    repo = "ocaml-imagelib";
    rev = "03fed7733825cef7e0465163f398f6af810e2e75";
    sha256 = "0h7vgyss42nhlfqpbdnb54nxq86rskqi2ilx8b87r0hi19hqx463";
  };

  patches = [ (fetchpatch {
    url = "https://github.com/rlepigre/ocaml-imagelib/pull/24/commits/4704fd44adcda62e0d96ea5b1927071326aa6111.patch";
    sha256 = "0ipjab1hfa2v2pnd8g1k3q2ia0plgiw7crm3fa4w2aqpzdyabkb9";
  }) ];

  propagatedBuildInputs = [ decompress ];

  meta = {
    description = "Image formats such as PNG and PPM in OCaml";
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
