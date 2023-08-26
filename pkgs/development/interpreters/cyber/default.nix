{ lib
, stdenv
, fetchFromGitHub
, zig_0_11
}:

stdenv.mkDerivation rec {
  pname = "cyber";
  version = "unstable-2023-08-24";

  src = fetchFromGitHub {
    owner = "fubark";
    repo = "cyber";
    rev = "be76bc13590285cffa502c3c97470a80ff1f27bd";
    hash = "sha256-DhGp+vHz+FfF9ZGopQshF2t0Q4/yeN7CEpIlPliPBgQ=";
  };

  nativeBuildInputs = [
    zig_0_11.hook
  ];

  zigBuildFlags = [
    "cli"
  ];

  env = {
    COMMIT = lib.substring 0 7 src.rev;
  };

  meta = with lib; {
    description = "A fast, efficient, and concurrent scripting language";
    homepage = "https://github.com/fubark/cyber";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    inherit (zig_0_11.meta) platforms;
    broken = stdenv.isDarwin;
  };
}
