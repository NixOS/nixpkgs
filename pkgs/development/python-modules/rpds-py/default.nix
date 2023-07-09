{ lib
, buildPythonPackage
, cargo
, fetchPypi
, pytestCheckHook
, pythonOlder
, rustc
, rustPlatform
}:

buildPythonPackage rec {
  pname = "rpds-py";
  version = "0.8.8";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "rpds_py";
    inherit version;
    hash = "sha256-MAuFeXQLBuJGI4tzDmNvMUp9jcR1vhhoZQ9dPdwpoNg=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-jg9oos4wqewIHe31c3DixIp6fssk742kqt4taWyOq4U=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    cargo
    rustc
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
