{ lib
, buildPythonPackage
, fetchFromGitHub
, matplotlib
, palettable
, pandas
, pytestCheckHook
, pythonOlder
, scipy
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "mizani";
  version = "0.9.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "has2k1";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-XV/Lqr/kGx+t26ALLY7wTp2Ez487yvExM1GUD4AH9Bc=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    matplotlib
    palettable
    pandas
    scipy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=mizani --cov-report=xml" ""
  '';

  pythonImportsCheck = [
    "mizani"
  ];

  meta = with lib; {
    description = "Scales for Python";
    homepage = "https://github.com/has2k1/mizani";
    changelog = "https://github.com/has2k1/mizani/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ samuela ];
  };
}
