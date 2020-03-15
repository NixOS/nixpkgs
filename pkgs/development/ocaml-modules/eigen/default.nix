{ stdenv, buildDune2Package, fetchFromGitHub, ctypes, libcxx }:

buildDune2Package rec {
  pname = "eigen";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "owlbarn";
    repo   = pname;
    rev    = version;
    sha256 = "1zaw03as14hyvfpyj6bjrfbcxp2ljdbqcqqgm53kms244mig425f";
  };

  minimumOCamlVersion = "4.02";

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin "-I${libcxx}/include/c++/v1";

  propagatedBuildInputs = [ ctypes ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Minimal/incomplete Ocaml interface to Eigen3, mostly for Owl";
    platforms = platforms.x86_64;
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.mit;
  };
}
