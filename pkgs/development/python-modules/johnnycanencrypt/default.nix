{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  libiconv,
  nettle,
  PCSC,
  pcsclite,
  pkg-config,
  pytestCheckHook,
  pythonOlder,
  rustPlatform,
  vcrpy,
}:

buildPythonPackage rec {
  pname = "johnnycanencrypt";
  version = "0.15.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "kushaldas";
    repo = "johnnycanencrypt";
    tag = "v${version}";
    hash = "sha256-tbHW3x+vwFz0nqFGWvgxjhw8XH6/YKz1uagU339SZyk=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-2kgp3RD2QbxL/Xk4iljjJZ8yEfo2umFtcN5CEtheyw8=";
  };

  build-system = with rustPlatform; [
    bindgenHook
    cargoSetupHook
    maturinBuildHook
  ];

  nativeBuildInputs =
    [ pkg-config ]
    ++ (with rustPlatform; [
      bindgenHook
      cargoSetupHook
      maturinBuildHook
    ]);

  buildInputs =
    [ nettle ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ pcsclite ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      PCSC
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
