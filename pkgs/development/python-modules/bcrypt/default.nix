{ lib
, buildPythonPackage
, fetchPypi
, libiconv
, pythonOlder
, pytestCheckHook
, rustPlatform
, setuptools-rust
}:

buildPythonPackage rec {
  pname = "bcrypt";
  version = "4.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-xZwXD8kiX6rQTd4bph2FtBOUbozi5fX1/zDf1nKD8xk=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    name = "${pname}-${version}";
    inherit src;
    sourceRoot = "${pname}-${version}/${cargoRoot}";
    sha256 = "sha256-HvfRLyUhlXVuvxWrtSDKx3rMKJbjvuiMcDY6g+pYFS0=";
  };

  cargoRoot = "src/_bcrypt";

  nativeBuildInputs = [
    setuptools-rust
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

  buildInputs = [
    libiconv
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
