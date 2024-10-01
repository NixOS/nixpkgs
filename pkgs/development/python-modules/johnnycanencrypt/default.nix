{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  rustPlatform,
  pkg-config,
  pcsclite,
  nettle,
  httpx,
  pytestCheckHook,
  pythonOlder,
  vcrpy,
  PCSC,
  libiconv,
}:

buildPythonPackage rec {
  pname = "johnnycanencrypt";
  version = "0.15.0";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "kushaldas";
    repo = "johnnycanencrypt";
    rev = "v${version}";
    hash = "sha256-tbHW3x+vwFz0nqFGWvgxjhw8XH6/YKz1uagU339SZyk=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-vDlMdzZgmaRkviEk8IjIN+Q5x95gnpQiW5c8fT+dats=";
  };

  format = "pyproject";

  propagatedBuildInputs = [ httpx ];

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
    homepage = "https://github.com/kushaldas/johnnycanencrypt";
    changelog = "https://github.com/kushaldas/johnnycanencrypt/blob/v${version}/changelog.md";
    description = "Python module for OpenPGP written in Rust";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
