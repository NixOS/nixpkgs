{ stdenv, fetchFromGitHub, cmake }:
stdenv.mkDerivation rec {
  name = "spirv-headers-${version}";
  version = "2019.1"; # spirv-tools version whose DEPS file calls for this commit

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "79b6681aadcb53c27d1052e5f8a0e82a981dbf2f"; # from spirv-tools' DEPS
    sha256 = "0flng2rdmc4ndq3j71h6wk1ibcjvhjrg2rzd6rv445vcsf0jh2pj";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Machine-readable components of the Khronos SPIR-V Registry";
    license = licenses.mit;
    maintainers = [ maintainers.ralith ];
  };
}
