{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  libiconv,
  nettle,
  pcsclite,
  pkg-config,
  pytestCheckHook,
  pythonOlder,
  rustPlatform,
  vcrpy,
}:

buildPythonPackage rec {
  pname = "johnnycanencrypt";
  version = "0.16.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "kushaldas";
    repo = "johnnycanencrypt";
    tag = "v${version}";
    hash = "sha256-9T8B6zG3zMOBMX9C+u34MGBAgQ8YR44CW2BTdO1CciI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-V1z16GKaSQVjp+stWir7kAO2wsnOYPdhKi4KzIKmKx8=";
  };

  build-system = with rustPlatform; [
    bindgenHook
    cargoSetupHook
    maturinBuildHook
  ];

  nativeBuildInputs = [
    pkg-config
  ]
  ++ (with rustPlatform; [
    bindgenHook
    cargoSetupHook
    maturinBuildHook
  ]);

  buildInputs = [
    nettle
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ pcsclite ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  dependencies = [ httpx ];

  nativeCheckInputs = [
    pytestCheckHook
    vcrpy
  ];

  preCheck = ''
    # import from $out
    rm -r johnnycanencrypt
  '';

  pythonImportsCheck = [ "johnnycanencrypt" ];

  meta = with lib; {
    description = "Python module for OpenPGP written in Rust";
    homepage = "https://github.com/kushaldas/johnnycanencrypt";
    changelog = "https://github.com/kushaldas/johnnycanencrypt/blob/v${version}/changelog.md";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
