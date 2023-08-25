{ lib
, stdenv
, fetchFromGitHub
, zig_0_11
}:

stdenv.mkDerivation rec {
  pname = "cyber";
  version = "unstable-2023-08-11";

  src = fetchFromGitHub {
    owner = "fubark";
    repo = "cyber";
    rev = "242ba2573cbac2acecc8c06878a8d754dd7a8716";
    hash = "sha256-jArkFdvWnHNouNGsTn8O2lbU7eZdLbPD0xEfkrFH5Aw=";
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
