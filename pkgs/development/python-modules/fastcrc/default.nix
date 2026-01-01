{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  rustPlatform,
  pytestCheckHook,
  pytest-benchmark,
  nix-update-script,
}:
let
  pname = "fastcrc";
<<<<<<< HEAD
  version = "0.3.4";
=======
  version = "0.3.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "overcat";
    repo = "fastcrc";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-iBbYiF0y/3Cax4P9+/gKS6FUBqZ3BleCwnpItsVd7Ps=";
=======
    hash = "sha256-yLrv/zqsjgygJAIJtztwxlm4s9o9EBVsCyx1jUXd7hA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
in
buildPythonPackage {
  inherit pname version src;
  pyproject = true;

  disabled = pythonOlder "3.7";

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
<<<<<<< HEAD
    hash = "sha256-VbS5xTqj+Flxxdg06MO34AZCVozlNgFvc+yKemEmCzs=";
=======
    hash = "sha256-9Vap8E71TkBIf4eIB2lapUqcMukdsHX4LR7U8AD77SU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  pythonImportsCheck = [ "fastcrc" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-benchmark
  ];

  pytestFlags = [ "--benchmark-disable" ];

  # Python source files interfere with testing
  preCheck = ''
    rm -r fastcrc
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Hyper-fast Python module for computing CRC(8, 16, 32, 64) checksum";
    homepage = "https://fastcrc.readthedocs.io/en/latest/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pluiedev ];
  };
}
