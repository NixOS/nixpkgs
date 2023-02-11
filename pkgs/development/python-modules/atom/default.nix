{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools-scm
, future
, cppy
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "atom";
  version = "0.8.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "nucleic";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-45c17lewJPo39ZWMaE8kyOo6n0A9f0m58TbMAiNAqeg=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  buildInputs = [
    cppy
  ];

  preCheck = ''
    rm -rf atom
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "atom.api"
  ];

  meta = with lib; {
    description = "Memory efficient Python objects";
    homepage = "https://github.com/nucleic/atom";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bhipple ];
  };
}
