{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest,
  tornado,
}:

buildPythonPackage {
  pname = "pytest-tornasync";
  version = "0.6.0.post2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "eukaryote";
    repo = "pytest-tornasync";
    # upstream does not keep git tags in sync with pypy releases
    # https://github.com/eukaryote/pytest-tornasync/issues/9
    rev = "c5f013f1f727f1ca1fcf8cc748bba7f4a2d79e56";
    hash = "sha256-ZvQBep+v2wWy3IZkC65hJQ4QmGZ3SmpRXK2UnB0LjxE=";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ tornado ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytest
    tornado
  ];

  checkPhase = ''
    pytest test
  '';

  meta = {
    description = "py.test plugin for testing Python 3.5+ Tornado code";
    homepage = "https://github.com/eukaryote/pytest-tornasync";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
