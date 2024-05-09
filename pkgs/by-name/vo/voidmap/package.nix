{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "voidmap";
  version = "1.1.5-unstable-2023-09-13";

  src = fetchFromGitHub {
    owner = "void-rs";
    repo = "void";
    rev = "ab32290632fa9477a7e59b884bdfa69fb4b91906";
    hash = "sha256-+P83psu+BYzgC/I/Ul7vrbZ99KIybd410/ycsIY1pGI=";
  };

  cargoHash = "sha256-+UhqGl7w2jtGBFgX4u/g8tGO0NJTkDAJdNfwe8RobPQ=";

  checkFlags = [
    # The test utilizes a redirect stdout to file with dup2 and breaks sandbox assumptions
    "--skip=screen::qc_input_events_dont_crash_void"
  ];

  meta = {
    description = "A terminal-based personal organizer";
    homepage = "https://github.com/void-rs/void";
    license = lib.licenses.gpl3Only;
    mainProgram = "void";
    maintainers = with lib.maintainers; [ poptart ];
    platforms = lib.platforms.linux;
  };
}
