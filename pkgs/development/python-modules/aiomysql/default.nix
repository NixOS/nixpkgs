{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, fetchpatch
, pymysql
, pythonOlder
, setuptools-scm
, wheel
=======
, pymysql
, pythonOlder
, setuptools-scm
, setuptools-scm-git-archive
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "aiomysql";
<<<<<<< HEAD
  version = "0.2.0";
=======
  version = "0.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = pname;
<<<<<<< HEAD
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
    setuptools-scm
    wheel
=======
    rev = "v${version}";
    hash = "sha256-rYEos2RuE2xI59httYlN21smBH4/fU4uT48FWwrI6Qg=";
  };

  nativeBuildInputs = [
    setuptools-scm
    setuptools-scm-git-archive
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
