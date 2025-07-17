{ lib
, buildPythonPackage
, fetchPypi
, fetchFromGitHub
, setuptools
, setuptools-scm
, requests
, pycryptodomex
, colorama
, prompt-toolkit
, keyring
, pykeepass
, asciitree
, bcrypt
, fido2_2
, flask
, flask-limiter
, protobuf
, psutil
, pyngrok
, pyperclip
, pysocks
, python-dotenv
, tabulate
, websockets
, pydantic
, fpdf2
, keeper-secrets-manager-core
, aiortc
}:
let
  fido2 = fido2_2;
in
buildPythonPackage rec {
  pname = "keepercommander";
  version = "17.1.3";
  pyproject = true;
  
  src = fetchFromGitHub {
    owner= "Keeper-Security";
    repo = "Commander";
    rev="21c5eabf05ca8031da97d3ab9b8bcdc8039c558c";
    hash="sha256-LxVv3n8RsxDM8a4EogN70zxphgVgiAb+xgx4ZZmveIw=";
  };

  nativeBuildInputs = [ setuptools setuptools-scm ];
  propagatedBuildInputs = [
    requests
    pycryptodomex
    colorama
    prompt-toolkit
    keyring
    pykeepass
    asciitree
    bcrypt
    fido2
    flask
    flask-limiter
    protobuf
    psutil
    pyngrok
    pyperclip
    pysocks
    python-dotenv
    tabulate
    websockets
    pydantic
    fpdf2
    keeper-secrets-manager-core
    aiortc
  ];
  pythonImportsCheck = [ "keepercommander" ];
  meta = {
    description = "Command-line interface and SDK for Keeper Password Manager";
    homepage = "https://github.com/Keeper-Security/Commander";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sdubey ];
  };
}