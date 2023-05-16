{ lib
, stdenv
, fetchFromGitHub
, buildPythonPackage
, rustPlatform
<<<<<<< HEAD
=======
, llvmPackages
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pkg-config
, pcsclite
, nettle
, httpx
, pytestCheckHook
, pythonOlder
, vcrpy
, PCSC
, libiconv
}:

buildPythonPackage rec {
  pname = "johnnycanencrypt";
<<<<<<< HEAD
  version = "0.14.1";
=======
  version = "0.13.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "kushaldas";
    repo = "johnnycanencrypt";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-13zIC+zH/BebMplUfdtiwEEVODS+jTURC1vudbmQPlA=";
=======
    hash = "sha256-1zHdV0QNYgeJIMaSljIMtqjpkwih2+s8jAaQnCumdgw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
<<<<<<< HEAD
    hash = "sha256-u3qKli76XGS0Ijg15BQzbFlfLPpBPFKh++EZLfnO9ps=";
=======
    hash = "sha256-nsVC2plY2yXjOZBvM4GYNQJqHR+ZWxfiDjPcTCoe6+0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  format = "pyproject";

<<<<<<< HEAD
=======
  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    httpx
  ];

  nativeBuildInputs = [
<<<<<<< HEAD
    pkg-config
  ] ++ (with rustPlatform; [
    bindgenHook
=======
    llvmPackages.clang
    pkg-config
  ] ++ (with rustPlatform; [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    cargoSetupHook
    maturinBuildHook
  ]);

  buildInputs = [
    nettle
  ] ++ lib.optionals stdenv.isLinux [
    pcsclite
  ] ++ lib.optionals stdenv.isDarwin [
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
