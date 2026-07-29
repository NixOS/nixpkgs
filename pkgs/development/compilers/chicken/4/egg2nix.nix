{
  lib,
  eggDerivation,
  fetchFromGitHub,
  chickenEggs,
  fetchpatch,
}:

# Note: This mostly reimplements the default.nix already contained in
# the tarball. Is there a nicer way than duplicating code?

eggDerivation rec {
  pname = "egg2nix";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "the-kenny";
    repo = "egg2nix";
    rev = version;
    sha256 = "sha256-5ov2SWVyTUQ6NHnZNPRywd9e7oIxHlVWv4uWbsNaj/s=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/the-kenny/egg2nix/commit/7d20ed520b8fe4debeefc78271c8c836015f95dc.patch";
      hash = "sha256-emMnxu6HnpcDWcO7rAe0VOy2ZPfPhqj5bQv9foOkjY0=";
    })
  ];

  buildInputs = with chickenEggs; [
    matchable
    http-client
  ];

  meta = {
    description = "Generate nix-expression from CHICKEN scheme eggs";
    mainProgram = "egg2nix";
    homepage = "https://github.com/the-kenny/egg2nix";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ corngood ];
  };
}
