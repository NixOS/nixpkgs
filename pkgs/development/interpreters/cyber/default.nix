{ lib
, stdenv
, fetchFromGitHub
, zig_0_11
}:

stdenv.mkDerivation rec {
  pname = "cyber";
  version = "unstable-2023-09-01";

  src = fetchFromGitHub {
    owner = "fubark";
    repo = "cyber";
    rev = "1dae891be5ca1e64ad8ab9d60be0b30e1ef28439";
    hash = "sha256-5GCIdk6XCJIXZLFsNMzo15Qhtj7zd/DOcARe8GXF2lc=";
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
