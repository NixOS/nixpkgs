{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, flit-core
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-raisin";
  version = "0.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "wimglenn";
    repo = "pytest-raisin";
    rev = "v${version}";
    hash = "sha256-BI0SWy671DYDTPH4iO811ku6SzpH4ho7eQFUA8PmxW8=";
  };

  patches = [
    # https://github.com/wimglenn/pytest-raisin/pull/8
    (fetchpatch {
      name = "replace-flit-with-flit-core.patch";
      url = "https://github.com/wimglenn/pytest-raisin/commit/3a4e4285e2c9b6610e3f9120c9eb2a52f83b0b86.patch";
      hash = "sha256-9ZqzaIZ55Epn2DAm1FzT8fpp4fiDOolPfnXv9zQ/IEA=";
    })
  ];

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    pytest
  ];

  # tests cause circular pytest-raisin already registered with pytest error
  doCheck = false;

  meta = with lib; {
    description = "Plugin enabling the use of exception instances with pytest.raises context";
    homepage = "https://github.com/wimglenn/pytest-raisin";
    license = licenses.mit;
    maintainers = with maintainers; [ aadibajpai ];
  };
}
