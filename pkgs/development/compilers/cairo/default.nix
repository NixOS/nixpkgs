{ lib
, rustPlatform
, fetchFromGitHub
, rustfmt
}:

rustPlatform.buildRustPackage rec {
  pname = "cairo";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "starkware-libs";
    repo = "cairo";
    rev = "v${version}";
    hash = "sha256-X8CqiikY1/S8/WxrZbcwOB+bz0PJsNpuLWLb+k3+5kw=";
  };

  cargoHash = "sha256-jrUH3vmTbbxod547JAE5sOSo+FR15XNgVpM15uXAsvg=";

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
