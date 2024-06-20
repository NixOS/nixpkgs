{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pynose";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mdmintz";
    repo = "pynose";
    rev = "refs/tags/v${version}";
    hash = "sha256-Oi+vwInqgsdZfr5abJUa4zkTktpEuG0m89d1O8Oot0Q=";
  };

  nativeBuildInputs = [ setuptools ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "pynose fixes nose to extend unittest and make testing easier";
    homepage = "https://github.com/mdmintz/pynose";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
