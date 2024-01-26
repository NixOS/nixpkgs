{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, packaging
, pytestCheckHook
, pytest-mock
}:

buildPythonPackage rec {
  pname = "luddite";
  version = "1.0.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jumptrading";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-JXIM7/5LO95oabM16GwAt3v3a8uldGpGXDWmVic8Ins=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--cov=luddite --cov-report=html --cov-report=term --no-cov-on-fail" "" \
      --replace "--disable-socket" ""
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    packaging
  ];

  pythonImportsCheck = [
    "luddite"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  meta = with lib; {
    description = "Checks for out-of-date package versions";
    homepage = "https://github.com/jumptrading/luddite";
    license = licenses.asl20;
    maintainers = with maintainers; [ emilytrau ];
  };
}
