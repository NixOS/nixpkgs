{ lib
, buildPythonPackage
, fetchFromGitHub
, pymysql
, pythonOlder
, setuptools-scm
, setuptools-scm-git-archive
}:

buildPythonPackage rec {
  pname = "aiomysql";
  version = "0.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-rYEos2RuE2xI59httYlN21smBH4/fU4uT48FWwrI6Qg=";
  };

  nativeBuildInputs = [
    setuptools-scm
    setuptools-scm-git-archive
  ];

  propagatedBuildInputs = [
    pymysql
  ];

  # Tests require MySQL database
  doCheck = false;

  pythonImportsCheck = [
    "aiomysql"
  ];

  meta = with lib; {
    description = "MySQL driver for asyncio";
    homepage = "https://github.com/aio-libs/aiomysql";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
