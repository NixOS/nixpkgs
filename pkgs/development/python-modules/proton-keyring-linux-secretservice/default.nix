{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, proton-keyring-linux
, pytestCheckHook
}:

buildPythonPackage {
  pname = "proton-keyring-linux-secretservice";
  version = "0.0.1-unstable-2023-04-14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-keyring-linux-secretservice";
    rev = "973d2646ec4d04bc270df53058df892950244e70";
    hash = "sha256-JlhvJBpbewT2c8k31CPMUlvvo/orWW1qfylFZLnDxeY=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    proton-keyring-linux
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=proton.keyring_linux.secretservice --cov-report html --cov-report term" ""
  '';

  pythonImportsCheck = [ "proton.keyring_linux" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "ProtonVPN component to access Linux's keyring secret service API";
    homepage = "https://github.com/ProtonVPN/python-proton-keyring-linux-secretservice";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
