{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  packaging,
  pytestCheckHook,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "luddite";
  version = "1.0.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jumptrading";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-iJ3h1XRBzLd4cBKFPNOlIV5Z5XJ/miscfIdkpPIpbJ8=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--cov=luddite --cov-report=html --cov-report=term --no-cov-on-fail" "" \
      --replace "--disable-socket" ""
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ packaging ];

  pythonImportsCheck = [ "luddite" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  meta = {
    description = "Checks for out-of-date package versions";
    mainProgram = "luddite";
    homepage = "https://github.com/jumptrading/luddite";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ emilytrau ];
  };
}
