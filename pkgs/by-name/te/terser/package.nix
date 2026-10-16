{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

buildNpmPackage rec {
  pname = "terser";
  version = "5.51.2";

  src = fetchFromGitHub {
    owner = "terser";
    repo = "terser";
    rev = "v${version}";
    hash = "sha256-6TLm5k5fXPokTCa9ZbXVtlGp12Xfg2eKsAMm2HLH7Qs=";
  };

  npmDepsHash = "sha256-j8wQy2Tk7Rh8jjv6g3MYirWrjKthpV16A5pr5Jt/rwo=";

  meta = {
    description = "JavaScript parser, mangler and compressor toolkit for ES6+";
    mainProgram = "terser";
    homepage = "https://terser.org";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ talyz ];
  };
}
