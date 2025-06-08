{
  lib,
  stdenv,
  buildDunePackage,
  fetchFromGitHub,
  ctypes,
  dune-configurator,
}:

buildDunePackage rec {
  pname = "eigen";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "owlbarn";
    repo = pname;
    rev = version;
    sha256 = "sha256-8V4DQ+b2rzy58NTenK1BsJEJiJKYV6hIp2fJWqczHRY=";
  };

  minimalOCamlVersion = "4.02";

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-I${lib.getInclude stdenv.cc.libcxx}/include/c++/v1";

  propagatedBuildInputs = [ ctypes ];

  buildInputs = [ dune-configurator ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Minimal/incomplete Ocaml interface to Eigen3, mostly for Owl";
    platforms = platforms.x86_64;
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.mit;
  };
}
