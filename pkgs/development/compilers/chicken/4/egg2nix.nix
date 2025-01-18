{
  lib,
  eggDerivation,
  fetchFromGitHub,
  chickenEggs,
}:

# Note: This mostly reimplements the default.nix already contained in
# the tarball. Is there a nicer way than duplicating code?

eggDerivation rec {
  name = "egg2nix-${version}";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "the-kenny";
    repo = "egg2nix";
    rev = version;
    sha256 = "sha256-5ov2SWVyTUQ6NHnZNPRywd9e7oIxHlVWv4uWbsNaj/s=";
  };

  buildInputs = with chickenEggs; [
    matchable
    http-client
  ];

  meta = with lib; {
    description = "Generate nix-expression from CHICKEN scheme eggs";
    mainProgram = "egg2nix";
    homepage = "https://github.com/the-kenny/egg2nix";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ corngood ];
  };
}
