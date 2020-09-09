{ lib
, rustPlatform
, python
, fetchpatch
, fetchFromGitHub
, pipInstallHook
, maturin
, pip
  # Check inputs
, pytestCheckHook
, numpy
}:

rustPlatform.buildRustPackage rec {
  pname = "retworkx";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = "retworkx";
    rev = version;
    sha256 = "1xqp6d39apkjvd0ad9vw81cp2iqzhpagfa4p171xqm3bwfn2imdc";
  };

  cargoSha256 = "0bma0l14jv5qhcsxck7vw3ak1w3c8v84cq4hii86i4iqk523zns5";
  cargoPatches = [
      ( fetchpatch {
        name = "retworkx-cargo-lock.patch";
        url = "https://github.com/Qiskit/retworkx/commit/a02fd33d357a92dbe9530696a6d85aa59fe8a5b9.patch";
        sha256 = "0gvxr1nqp9ll4skfks4p4d964pshal25kb1nbfzhpyipnzddizr5";
      } )
  ];

  propagatedBuildInputs = [ python ];

  nativeBuildInputs = [ pipInstallHook maturin pip ];

  # Need to check AFTER python wheel is installed (b/c using Rust Build, not buildPythonPackage)
  doCheck = false;
  doInstallCheck = true;

  buildPhase = ''
    runHook preBuild
    maturin build --release --manylinux off --strip --interpreter ${python.interpreter}
    runHook postBuild
  '';

  installPhase = ''
    install -Dm644 -t dist target/wheels/*.whl
    pipInstallPhase
  '';

  installCheckInputs = [ pytestCheckHook numpy ];
  preCheck = ''
    export TESTDIR=$(mktemp -d)
    cp -r $TMP/$sourceRoot/tests $TESTDIR
    pushd $TESTDIR
  '';
  postCheck = "popd";

  meta = with lib; {
    description = "A python graph library implemented in Rust.";
    homepage = "https://retworkx.readthedocs.io/en/latest/index.html";
    downloadPage = "https://github.com/Qiskit/retworkx/releases";
    changelog = "https://github.com/Qiskit/retworkx/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
