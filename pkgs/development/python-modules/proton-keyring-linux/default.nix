{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, keyring
, proton-core
, pytestCheckHook
}:

buildPythonPackage {
  pname = "proton-keyring-linux";
  version = "0.0.1-unstable-2023-04-14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-keyring-linux";
    rev = "5ff3c7f9a1a162836649502dd23c2fbe1f487d73";
    hash = "sha256-4d8ZePG8imURhdNtLbraMRisrTLoRvJ+L2UuuOo3MPM=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    keyring
    proton-core
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=proton.keyring_linux.core --cov-report html --cov-report term" ""
  '';

  pythonImportsCheck = [ "proton.keyring_linux.core" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "ProtonVPN core component to access Linux's keyring";
    homepage = "https://github.com/ProtonVPN/python-proton-keyring-linux";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
