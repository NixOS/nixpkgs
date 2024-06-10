{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  wheel,
  pint,
  pandas,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pint-pandas";
  version = "0.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "hgrecco";
    repo = "pint-pandas";
    rev = version;
    hash = "sha256-FuH6wksSCkkL2AyQN46hwTnfeAZFwkWRl6KEEhsxmUY=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    pint
    pandas
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Pandas support for pint";
    license = licenses.bsd3;
    homepage = "https://github.com/hgrecco/pint-pandas";
    maintainers = with maintainers; [ doronbehar ];
  };
}
