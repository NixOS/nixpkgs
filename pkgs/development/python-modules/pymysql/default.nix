{ lib
, buildPythonPackage
, fetchFromGitHub
, cryptography
, setuptools
, build
}:

buildPythonPackage rec {
  pname = "PyMySQL";
  version = "1.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    inherit pname;
    owner = "PyMySQL";
    repo = "PyMySQL";
    rev = "v${version}";
    sha256 = "sha256-j9RF4vPIFg6RvV5xREL71RAlXM7YWP0LULghlZC/1yA=";
  };

  propagatedBuildInputs = [ cryptography ];

  nativeBuildInputs = [
    setuptools
    build
  ];

  meta = with lib; {
    description = "Pure Python MySQL Client";
    homepage = "https://github.com/PyMySQL/PyMySQL";
    license = licenses.mit;
    maintainers = [ maintainers.kalbasit ];
  };
}
