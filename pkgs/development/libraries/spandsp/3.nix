{
  fetchFromGitHub,
  callPackage,
  libjpeg,
}:

((callPackage ./common.nix { }) {
  version = "3.0.0";
  src = fetchFromGitHub {
    owner = "freeswitch";
    repo = "spandsp";
    rev = "6ec23e5a7e411a22d59e5678d12c4d2942c4a4b6"; # upstream does not seem to believe in tags
    hash = "sha256-x5cmFhJ/OVnIKUWUX0HOz73XRJoU2W1diSv+4VPSgA8=";
  };

  patches = [
    # https://github.com/freeswitch/spandsp/pull/120
    ./Fix-buffer-overrun-in-t85-tests.patch
  ];
}).overrideAttrs
  (
    finalAttrs: previousAttrs: {
      propagatedBuildInputs = previousAttrs.propagatedBuildInputs or [ ] ++ [
        libjpeg
      ];
    }
  )
