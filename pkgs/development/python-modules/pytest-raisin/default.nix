{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit,
  pytest,
}:

buildPythonPackage rec {
  pname = "pytest-raisin";
  version = "0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wimglenn";
    repo = "pytest-raisin";
    rev = "v${version}";
    hash = "sha256-BI0SWy671DYDTPH4iO811ku6SzpH4ho7eQFUA8PmxW8=";
  };

  nativeBuildInputs = [ flit ];

  propagatedBuildInputs = [ pytest ];

  # tests cause circular pytest-raisin already registered with pytest error
  doCheck = false;

  meta = {
    description = "Plugin enabling the use of exception instances with pytest.raises context";
    homepage = "https://github.com/wimglenn/pytest-raisin";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aadibajpai ];
  };
}
