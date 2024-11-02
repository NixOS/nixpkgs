{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPy27,
  pytest,
  tornado,
}:

buildPythonPackage rec {
  pname = "pytest-tornasync";
  version = "0.6.0.post2";
  format = "setuptools";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "eukaryote";
    repo = pname;
    # upstream does not keep git tags in sync with pypy releases
    # https://github.com/eukaryote/pytest-tornasync/issues/9
    rev = "c5f013f1f727f1ca1fcf8cc748bba7f4a2d79e56";
    sha256 = "04cg1cfrr55dbi8nljkpcsc103i5c6p0nr46vjr0bnxgkxx03x36";
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

  meta = with lib; {
    description = "py.test plugin for testing Python 3.5+ Tornado code";
    homepage = "https://github.com/eukaryote/pytest-tornasync";
    license = licenses.mit;
    maintainers = [ ];
  };
}
