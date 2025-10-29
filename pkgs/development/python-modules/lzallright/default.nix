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
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "vlaci";
    repo = "lzallright";
    rev = "v${version}";
    hash = "sha256-bnGnx+CKcneBWd5tpYWxEPp5f3hvGxM+8QcD2NKX4Tw=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-RxR1EFssGCp7etTdh56LSEfDQsx8uPrQTVqTsDVvkHo=";
  };

  format = "pyproject";

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

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
