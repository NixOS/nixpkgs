{ lib
, buildPythonPackage
, rustPlatform
, setuptools
, setuptools-rust
, isPyPy
, fetchPypi
, pythonOlder
, cffi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "bcrypt";
  version = "4.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xZwXD8kiX6rQTd4bph2FtBOUbozi5fX1/zDf1nKD8xk=";
  };

  cargoRoot = "src/_bcrypt";
  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "${pname}-${version}/${cargoRoot}";
    name = "${pname}-${version}";
    hash = "sha256-HvfRLyUhlXVuvxWrtSDKx3rMKJbjvuiMcDY6g+pYFS0=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-rust
    rustPlatform.cargoSetupHook
  ] ++ (with rustPlatform; [
    rust.cargo
    rust.rustc
  ]);

  propagatedBuildInputs = [
    cffi
  ];

  propagatedNativeBuildInputs = [
    cffi
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "bcrypt"
  ];

  meta = with lib; {
    description = "Modern password hashing for your software and your servers";
    homepage = "https://github.com/pyca/bcrypt/";
    license = licenses.asl20;
    maintainers = with maintainers; [ domenkozar ];
  };
}
