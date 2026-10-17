{
  lib,
  stdenv,
  buildPythonPackage,
  callPackage,
  fetchFromGitHub,
  rustPlatform,
  libiconv,
}:

buildPythonPackage (finalAttrs: {
  pname = "lzallright";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "vlaci";
    repo = "lzallright";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AXJ4wsPaH/l31L4j/+g/HHJVGV5G0p4U0Dhe55aSvB4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-DujRsarE8S56aN5eAPJsjvRSRCYRxboE5mzePVwcupI=";
  };

  pyproject = true;

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

  meta = {
    description = ''
      A Python 3.8+ binding for lzokay library which is an MIT licensed
      a minimal, C++14 implementation of the LZO compression format.
    '';
    homepage = "https://github.com/vlaci/lzallright";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vlaci ];
  };
})
