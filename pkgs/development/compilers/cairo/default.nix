{ lib
, rustPlatform
, fetchFromGitHub
, rustfmt
}:

rustPlatform.buildRustPackage rec {
  pname = "cairo";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "starkware-libs";
    repo = "cairo";
    rev = "v${version}";
    hash = "sha256-5UOLfsNgtg5EDDId23ysmWfeqMeh8R2UfMeBAtFCx6s=";
  };

  cargoHash = "sha256-YoPStyPeEqLoUvGLEPwXR8XVhXtb6XwFuPNoDCiT7OA=";

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
