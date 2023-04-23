{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
, flit-core
, mock
}:

buildPythonPackage rec {
  pname = "installer";
  version = "0.7.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pradyunsg";
    repo = pname;
    rev = version;
    hash = "sha256-thHghU+1Alpay5r9Dc3v7ATRFfYKV8l9qR0nbGOOX/A=";
  };

  nativeBuildInputs = [ flit-core ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ];

  meta = with lib; {
    changelog = "https://github.com/pypa/installer/blob/${src.rev}/docs/changelog.md";
    homepage = "https://github.com/pradyunsg/installer";
    description = "A low-level library for installing a Python package from a wheel distribution";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud fridh ];
  };
}
