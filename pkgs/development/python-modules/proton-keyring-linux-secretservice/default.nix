{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  proton-keyring-linux,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "proton-keyring-linux-secretservice";
  version = "0.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-keyring-linux-secretservice";
    rev = "refs/tags/v${version}";
    hash = "sha256-IZPT2bL/1YD2TH/djwIQHUE1RRbYMTkQDacjjoqDQWo=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ proton-keyring-linux ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=proton.keyring_linux.secretservice --cov-report html --cov-report term" ""
  '';

  pythonImportsCheck = [ "proton.keyring_linux" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "ProtonVPN component to access Linux's keyring secret service API";
    homepage = "https://github.com/ProtonVPN/python-proton-keyring-linux-secretservice";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
