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
  version = "0.9.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "rpds_py";
    inherit version;
    hash = "sha256-jXDo8UkA8mV8JJ6k3vljvthqKbgfgfW3a1qSFWgN6UU=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-2LiQ+beFj9+kykObPNtqcg+F+8wBDzvWcauwDLHa7Yo=";
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
