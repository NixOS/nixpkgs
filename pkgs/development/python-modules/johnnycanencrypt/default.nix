{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pipInstallHook
, llvmPackages
, pkg-config
, maturin
, pcsclite
, nettle
, python
, requests
, vcrpy
, numpy
, pytestCheckHook
, pythonOlder
, PCSC
}:

rustPlatform.buildRustPackage rec {
  pname = "johnnycanencrypt";
  version = "0.5.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "kushaldas";
    repo = "johnnycanencrypt";
    rev = "v${version}";
    sha256 = "192wfrlyylrpzq70yki421mi1smk8q2cyki2a1d03q7h6apib3j4";
  };
  cargoPatches = [ ./Cargo.lock.patch ];

  cargoSha256 = "0ifvpdizcdp2c5x2x2j1bhhy5a75q0pk7a63dmh52mlpmh45fy6r";

  LIBCLANG_PATH = llvmPackages.libclang + "/lib";

  propagatedBuildInputs = [
    requests
    vcrpy
  ];

  nativeBuildInputs = [
    llvmPackages.clang
    pkg-config
    python
    maturin
    pipInstallHook
  ];

  buildInputs = [
    pcsclite
    nettle
  ] ++ lib.optionals stdenv.isDarwin [ PCSC ];

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
  '';

  buildPhase = ''
    runHook preBuild
    maturin build --release --manylinux off --strip --cargo-extra-args="-j $NIX_BUILD_CORES --frozen"
    runHook postBuild
  '';

  installPhase = ''
    install -Dm644 -t dist target/wheels/*.whl
    pipInstallPhase
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
