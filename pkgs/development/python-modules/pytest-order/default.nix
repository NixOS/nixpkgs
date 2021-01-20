{ buildPythonPackage
, fetchFromGitHub
, lib
, pytest
, pytest-xdist
, pytest-dependency
, pytest-mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-order";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "mrbean-bremen";
    repo = "pytest-order";
    rev = "486e0966c651f3c57bbc2172e9914e478de55b6b";
    sha256 = "1mfw2x8r5hn4g5cd6jca92lvqrd9297gsc5bvz18dzjlrm8zlycc";
  };

  propagatedBuildInputs = [ pytest ];

  checkInputs = [
    pytestCheckHook
    pytest-xdist
    pytest-dependency
    pytest-mock
  ];

  meta = {
    description = "Pytest plugin that allows you to customize the order in which your tests are run";
    homepage = "https://github.com/mrbean-bremen/pytest-order";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jacg ];
  };
}
