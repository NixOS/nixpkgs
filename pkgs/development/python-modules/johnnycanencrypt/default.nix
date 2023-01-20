{ lib
, stdenv
, fetchPypi
, buildPythonPackage
, rustPlatform
, llvmPackages
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
  version = "0.12.0";
  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aGhM/uyYE7l0h6L00qp+HRUVaj7s/tnHWIHJpLAkmR4=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-fcwDxkUFtA6LS77xdLktNnZJXmyl/ZzArvIW69SPpmI=";
  };

  format = "pyproject";

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  propagatedBuildInputs = [
    httpx
  ];

  nativeBuildInputs = [
    llvmPackages.clang
    pkg-config
  ] ++ (with rustPlatform; [
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

  checkInputs = [
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
