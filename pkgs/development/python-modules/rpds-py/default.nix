{ stdenv
, lib
, buildPythonPackage
, cargo
, fetchPypi
, pytestCheckHook
, pythonOlder
, rustc
, rustPlatform
, libiconv
}:

buildPythonPackage rec {
  pname = "rpds-py";
  version = "0.10.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "rpds_py";
    inherit version;
    hash = "sha256-421zaTY9JwfV9olQpkxOAlmR6wF32wHMtqpvrK5Itp8=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-FXjk1Y/Eol4d1xvwz0S42OycZV0cSHM36H+zjEmNPCQ=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    cargo
    rustc
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "rpds"
  ];

  meta = with lib; {
    description = "Python bindings to Rust's persistent data structures (rpds";
    homepage = "https://pypi.org/project/rpds-py/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
