{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  packaging,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "luddite";
  version = "1.0.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jumptrading";
    repo = "luddite";
    tag = "v${version}";
    hash = "sha256-iJ3h1XRBzLd4cBKFPNOlIV5Z5XJ/miscfIdkpPIpbJ8=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--disable-socket" ""
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ packaging ];

  pythonImportsCheck = [ "luddite" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pytest-mock
  ];

  meta = with lib; {
    description = "Checks for out-of-date package versions";
    mainProgram = "luddite";
    homepage = "https://github.com/jumptrading/luddite";
    license = licenses.asl20;
    maintainers = with maintainers; [ emilytrau ];
  };
}
