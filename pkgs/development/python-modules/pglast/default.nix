{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, setuptools
, pytest-cov
, pytest
}:

buildPythonPackage rec {
  pname = "pglast";
  version = "3.0";

  # PyPI tarball does not include all the required files
  src = fetchFromGitHub {
    owner = "lelit";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "0yi24wj19rzw5dvppm8g3hnfskyzbrqw14q8x9f2q5zi8g6xnnrd";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [ setuptools ];

  checkInputs = [ pytest pytest-cov ];

  pythonImportsCheck = [ "pglast" ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    homepage = "https://github.com/lelit/pglast";
    description = "PostgreSQL Languages AST and statements prettifier";
    changelog = "https://github.com/lelit/pglast/raw/v${version}/CHANGES.rst";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.marsam ];
  };
}
