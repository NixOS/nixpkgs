{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  libiconv,
  hypothesis,
  numpy,
  pytest-xdist,
  pytestCheckHook,
  pkg-config,
  isa-l,
  c-blosc2,
}:

buildPythonPackage rec {
  pname = "cramjam";
  version = "2.9.1"; # make sure to update maturinBuildFlags
  pyproject = true;

  src = fetchFromGitHub {
    owner = "milesgranger";
    repo = "pyrus-cramjam";
    tag = "v${version}";
    hash = "sha256-s+dKoZftI+aXcie1quAo/Xmlt1BQrzoCjwesDiaNABY=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-xrqlVgAUTsqz7AOQdPCSxjRd/Z3ZVpr0qphw6qN6Wys=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
    pkg-config
  ];

  buildInputs = [
    isa-l
    c-blosc2
  ] ++ lib.optional stdenv.hostPlatform.isDarwin libiconv;

  maturinBuildFlags = [
    "--no-default-features"
    "--features"
    # default features from Cargo.toml, modified to specify -shared
    "extension-module,snappy,lz4,bzip2,brotli,xz,zstd,gzip,zlib,deflate,blosc2-shared,use-system-isal-shared,igzip-shared,ideflate-shared,izlib-shared,use-system-blosc2-shared"
  ];

  nativeCheckInputs = [
    hypothesis
    numpy
    pytest-xdist
    pytestCheckHook
  ];

  # fix Hypothesis timeouts
  preCheck = ''
    echo >> tests/conftest.py <<EOF

    import hypothesis

    hypothesis.settings.register_profile(
      "ci",
      deadline=None,
      print_blob=True,
      derandomize=True,
    )
    EOF
  '';

  pytestFlagsArray = [
    "tests"
    "--hypothesis-profile"
    "ci"
  ];

  disabledTestPaths = [
    # test_variants.py appears to be flaky
    #
    # https://github.com/NixOS/nixpkgs/pull/311584#issuecomment-2117656380
    "tests/test_variants.py"
  ];

  pythonImportsCheck = [ "cramjam" ];

  meta = with lib; {
    description = "Thin Python bindings to de/compression algorithms in Rust";
    homepage = "https://github.com/milesgranger/pyrus-cramjam";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ veprbl ];
  };
}
