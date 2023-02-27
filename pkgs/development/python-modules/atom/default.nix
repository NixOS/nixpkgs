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
  version = "0.9.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "nucleic";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-zxFYsINlDyGQGGh+u7vwyzAitRXe3OM1//HvCtuZ/p8=";
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
