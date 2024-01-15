{ lib
, rustPlatform
, fetchFromGitHub
, rustfmt
}:

rustPlatform.buildRustPackage rec {
  pname = "cairo";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "starkware-libs";
    repo = "cairo";
    rev = "v${version}";
    hash = "sha256-5bCPklk9u21/9cZYisszK0Lo7is9+iFrQxve41Fy5hg=";
  };

  cargoPatches = [
    # Upstream Cargo.lock is not up-to-date.
    # https://github.com/starkware-libs/cairo/issues/4530
    ./ensure-consistency-of-cargo-lock.patch
  ];
  cargoHash = "sha256-YCW6nwmUXMiP65QHCH6k29672gIkuz+MCmTqI+qaOyA=";

  nativeCheckInputs = [
    rustfmt
  ];

  checkFlags = [
    # Requires a mythical rustfmt 2.0 or a nightly compiler
    "--skip=golden_test::sourcegen_ast"
  ];

  postInstall = ''
    # The core library is needed for compilation.
    cp -r corelib $out/
  '';

  meta = with lib; {
    description = "Turing-complete language for creating provable programs for general computation";
    homepage = "https://github.com/starkware-libs/cairo";
    license = licenses.asl20;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
