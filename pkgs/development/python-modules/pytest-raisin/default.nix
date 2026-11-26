{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchurl,
  flit-core_3,
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

  patches = [
    (fetchurl {
      name = "flit-migration.patch";
      url = "https://github.com/wimglenn/pytest-raisin/commit/3a4e4285e2c9b6610e3f9120c9eb2a52f83b0b86.patch";
      hash = "sha256-H7LK2wybUZSeQd3W0pXehTctE7q7s7uioaSUxVwWVTI=";
    })
  ];

  nativeBuildInputs = [ flit-core_3 ];

  buildInputs = [ pytest ];

  # tests cause circular pytest-raisin already registered with pytest error
  doCheck = false;

  meta = {
    description = "Plugin enabling the use of exception instances with pytest.raises context";
    homepage = "https://github.com/wimglenn/pytest-raisin";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aadibajpai ];
  };
}
