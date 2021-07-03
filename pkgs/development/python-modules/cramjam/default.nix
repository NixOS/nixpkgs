{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, rustPlatform
, numpy
}:

buildPythonPackage rec {
  pname = "cramjam";
  version = "2.3.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "milesgranger";
    repo = "pyrus-cramjam";
    rev = "v${version}";
    sha256 = "1gbsnbk6y3i0ji69122v3xdrf2wgp1fnp6bag6vzi7yc76drywkx";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit patches src;
    name = "${pname}-${version}";
    sha256 = "0cvv9kar3q38aiz57vihhniyzzr7k6wpyc2g9fcmcq4chnbrpcd1";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  checkInputs = [
    numpy
    pytestCheckHook
  ];

  patches = [ ./Cargo.lock.patch ];

  preCheck = ''
    export TESTDIR=$(mktemp -d)
    cp -r tests/ $TESTDIR
    pushd $TESTDIR
  '';

  postCheck = ''
    popd
  '';

  pythonImportsCheck = [ "cramjam" ];

  meta = with lib; {
    description = "Python bindings to de/compression algorithms in Rust";
    homepage = "https://github.com/milesgranger/pyrus-cramjam";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
