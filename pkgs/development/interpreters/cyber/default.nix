{
  lib,
  stdenv,
  fetchFromGitHub,
  zig_0_11,
}:

stdenv.mkDerivation rec {
  pname = "cyber";
  version = "unstable-2023-09-19";

  src = fetchFromGitHub {
    owner = "fubark";
    repo = "cyber";
    rev = "f95cd189cf090d26542a87b1d2ced461e75fa1a7";
    hash = "sha256-ctEd8doXMKq3L9/T+jOcWqlBQN0pVhsu9DjBXsg/u/4=";
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
    mainProgram = "cyber";
    homepage = "https://github.com/fubark/cyber";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    inherit (zig_0_11.meta) platforms;
    broken = stdenv.isDarwin;
  };
}
