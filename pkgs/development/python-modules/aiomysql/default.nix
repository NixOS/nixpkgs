{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pymysql,
  pythonOlder,
  setuptools,
  setuptools-scm,
  wheel,
}:

buildPythonPackage rec {
  pname = "aiomysql";
  version = "0.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiomysql";
    rev = "refs/tags/v${version}";
    hash = "sha256-m/EgoBU3e+s3soXyYtACMDSjJfMLBOk/00qPtgawwQ8=";
  };

  patches = [
    # https://github.com/aio-libs/aiomysql/pull/955
    (fetchpatch {
      name = "remove-setuptools-scm-git-archive-dependency.patch";
      url = "https://github.com/aio-libs/aiomysql/commit/fee997d2e848b634a84ce0c4e9025e3b3e761640.patch";
      hash = "sha256-qKcOfdDaA9DLS2fdHOEUW37aCCdtZjN0zsFV9dK/umQ=";
      includes = [ "pyproject.toml" ];
    })
  ];

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [ pymysql ];

  # Tests require MySQL database
  doCheck = false;

  pythonImportsCheck = [ "aiomysql" ];

  meta = with lib; {
    description = "MySQL driver for asyncio";
    homepage = "https://github.com/aio-libs/aiomysql";
    license = licenses.mit;
    maintainers = [ ];
  };
}
