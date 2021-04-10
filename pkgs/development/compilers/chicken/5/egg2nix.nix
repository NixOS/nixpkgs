{ stdenv, eggDerivation, fetchFromGitHub, chickenEggs }:

# Note: This mostly reimplements the default.nix already contained in
# the tarball. Is there a nicer way than duplicating code?

let
  version = "c5-git";
in
eggDerivation {
  src = fetchFromGitHub {
    owner = "corngood";
    repo = "egg2nix";
    # from the chicken-5 branch
    rev = "26039936505a301ad3d467c6aa54300cc400993b";
    sha256 = "0mykaj1c3hccilm2vkb2qss1d8xib5mcksam0wsmmq2c2pm4mvii";
  };

  name = "egg2nix-${version}";
  buildInputs = with chickenEggs; [
    args matchable
  ];

  meta = {
    description = "Generate nix-expression from CHICKEN scheme eggs";
    homepage = "https://github.com/the-kenny/egg2nix";
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ corngood ];
  };
}
