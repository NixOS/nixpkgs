{
  lib,
  stdenv,
  buildPythonPackage,
  callPackage,
  fetchFromGitHub,
  rustPlatform,
  libiconv,
}:

buildPythonPackage rec {
  pname = "lzallright";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "vlaci";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6Dez14qlZ7cnVQfaiTHGuiTSAHvBoKtolgKF7ne9ASw=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-ZYFAWkcDdX10024hc+gdARyaJFpNNcXf+gGLxBP5VlA=";
  };

  format = "pyproject";

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  pythonImportsCheck = [ "lzallright" ];

  doCheck = false;

  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  meta = with lib; {
    description = ''
      A Python 3.8+ binding for lzokay library which is an MIT licensed
      a minimal, C++14 implementation of the LZO compression format.
    '';
    homepage = "https://github.com/vlaci/lzallright";
    license = licenses.mit;
    maintainers = with maintainers; [ vlaci ];
  };
}
