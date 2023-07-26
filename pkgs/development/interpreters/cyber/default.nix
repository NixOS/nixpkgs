{ lib
, stdenv
, fetchFromGitHub
, zig_0_11
}:

stdenv.mkDerivation rec {
  pname = "cyber";
  version = "unstable-2023-09-07";

  src = fetchFromGitHub {
    owner = "fubark";
    repo = "cyber";
    rev = "98022d0b8d266ee4f9d8c524a42abad3ad4134c9";
    hash = "sha256-FEvNSHG/sMB1jBjbBaunGxb6/fSvKhKschFvghsW2Ls=";
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
