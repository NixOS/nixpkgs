{ lib
, stdenv
, fetchFromGitHub
, buildPythonPackage
, rustPlatform
, llvmPackages
, pkg-config
, pcsclite
, nettle
, requests
, vcrpy
, numpy
, pytestCheckHook
, pythonOlder
, PCSC
, libiconv
}:

buildPythonPackage rec {
  pname = "johnnycanencrypt";
  version = "0.6.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "kushaldas";
    repo = "johnnycanencrypt";
    rev = "v${version}";
    sha256 = "0b1yfddf38dicmjgnw9mk5g0iisa5yq6l9cj6kfskhyrznasvz3g";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit patches src;
    name = "${pname}-${version}";
    hash = "sha256-1dRFC59GY7M99LvQWy2eXPesmLX5k46rN8l4suLYkQY=";
  };

  format = "pyproject";

  patches = [ ./Cargo.lock.patch ];

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  propagatedBuildInputs = [
    requests
    vcrpy
  ];

  nativeBuildInputs = [
    llvmPackages.clang
    pkg-config
  ] ++ (with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ]);

  buildInputs = [
    pcsclite
    nettle
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

  # Remove with the next release after 0.5.0. This change is required
  # for compatibility with maturin 0.9.0.
  postPatch = ''
    sed '/project-url = /d' -i Cargo.toml
    substituteInPlace pyproject.toml \
      --replace 'manylinux = "off"' 'skip-auditwheel = true'
  '';

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
