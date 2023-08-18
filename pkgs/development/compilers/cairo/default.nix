{ lib
, rustPlatform
, fetchFromGitHub
, rustfmt
}:

rustPlatform.buildRustPackage rec {
  pname = "cairo";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "starkware-libs";
    repo = "cairo";
    rev = "v${version}";
    hash = "sha256-CgQzS4hxUtLxBTvHt8HGLXVl+trG+e0e0XF6zkr0I+g=";
  };

  cargoHash = "sha256-rJ4vUJDXbJ6ak79j3/AcPULxQkNxz7hSA8vrButx4zM=";

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
