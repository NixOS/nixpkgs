{
  build-idris-package,
  fetchFromGitHub,
  contrib,
  effects,
  libmicrohttpd,
  lib,
}:
build-idris-package {
  pname = "mhd";
  version = "2016-04-22";

  ipkgName = "MHD";
  idrisDeps = [
    contrib
    effects
  ];

  extraBuildInputs = [ libmicrohttpd ];

  src = fetchFromGitHub {
    owner = "colin-adams";
    repo = "idris-libmicrohttpd";
    rev = "a8808bc06fa292d4b3389f32cb00716e43122a46";
    hash = "sha256-pFvy4dLM/z63vIv69zQqevHNHVOmRb1FmZDYNSIOd3M=";
  };

  meta = {
    description = "Binding of the GNU libmicrohttpd library to the Idris C backend";
    homepage = "https://github.com/colin-adams/idris-libmicrohttpd";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
