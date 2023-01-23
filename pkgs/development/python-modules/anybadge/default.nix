{ lib
, fetchFromGitHub
, buildPythonPackage
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "anybadge";
  version = "1.14.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jongracecox";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-+CkkFCShCYtxKiCWRQcgTFcekc/g7ujQj9MdnG1+a0A=";
  };

  # setup.py reads its version from the TRAVIS_TAG environment variable
  TRAVIS_TAG = "v${version}";

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "anybadge"
  ];

  meta = with lib; {
    description = "Python tool for generating badges for your projects";
    homepage = "https://github.com/jongracecox/anybadge";
    license = licenses.mit;
    maintainers = with maintainers; [ fabiangd ];
  };
}
