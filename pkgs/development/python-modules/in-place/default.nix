{ buildPythonPackage
, fetchFromGitHub
, lib
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "in-place";
  version = "1.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jwodder";
    repo = "inplace";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-TfWfSb1GslzcT30/xvBg5Xui7ptp7+g89Fq/giLCoQ8=";
  };

  postPatch = ''
    substituteInPlace tox.ini --replace "--cov=in_place --no-cov-on-fail" ""
  '';

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "in_place" ];

  meta = with lib; {
    description = "In-place file processing";
    homepage = "https://github.com/jwodder/inplace";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
