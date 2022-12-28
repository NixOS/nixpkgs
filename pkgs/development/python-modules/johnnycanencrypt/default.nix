{ lib
, stdenv
, fetchFromGitHub
, buildPythonPackage
, rustPlatform
, llvmPackages
, pkg-config
, pcsclite
, nettle
, httpx
, numpy
, pytestCheckHook
, pythonOlder
, PCSC
, libiconv
}:

buildPythonPackage rec {
  pname = "johnnycanencrypt";
  version = "0.11.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "kushaldas";
    repo = "johnnycanencrypt";
    rev = "v${version}";
    hash = "sha256-YhuYejxuKZEv1xQ1fQcXSkt9I80iJOJ6MecG622JJJo=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit patches src;
    name = "${pname}-${version}";
    hash = "sha256-r2NU1e3yeZDLOBy9pndGYM3JoH6BBKQkXMLsJR6PTRs=";
  };

  format = "pyproject";

  # https://github.com/kushaldas/johnnycanencrypt/issues/125
  patches = [ ./Cargo.lock.patch ];

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

  # Needed b/c need to check AFTER python wheel is installed (using Rust Build, not buildPythonPackage)
  doCheck = false;
  doInstallCheck = true;

  installCheckInputs = [
    pytestCheckHook
    numpy
  ];

  preCheck = ''
    export TESTDIR=$(mktemp -d)
    cp -r tests/ $TESTDIR
    pushd $TESTDIR
  '';

  postCheck = ''
    popd
  '';

  pythonImportsCheck = [ "johnnycanencrypt" ];

  meta = with lib; {
    homepage = "https://github.com/kushaldas/johnnycanencrypt";
    description = "Python module for OpenPGP written in Rust";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
