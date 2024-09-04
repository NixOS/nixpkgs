{ lib, stdenv, buildDunePackage, fetchFromGitHub, ctypes, libcxx }:

buildDunePackage rec {
  pname = "eigen";
  version = "0.2.0";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "owlbarn";
    repo   = pname;
    rev    = version;
    sha256 = "1zaw03as14hyvfpyj6bjrfbcxp2ljdbqcqqgm53kms244mig425f";
  };

  minimalOCamlVersion = "4.02";

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-I${lib.getDev libcxx}/include/c++/v1";

  propagatedBuildInputs = [ ctypes ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Minimal/incomplete Ocaml interface to Eigen3, mostly for Owl";
    platforms = platforms.x86_64;
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.mit;
  };
}
