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
  version = "0.10.3";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "rpds_py";
    inherit version;
    hash = "sha256-/MHrt1YaPiSmWI98be0V2ArsIsZqBwx1dVm1exf/0cs=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-iWy6BHVsKsZB0SVrh3CVhryaavk4gAQVvRdu9xBiDRg=";
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
