{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pymysql
, pythonOlder
, setuptools-scm
, setuptools-scm-git-archive
, wheel
}:

buildPythonPackage rec {
  pname = "aiomysql";
  version = "0.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-m/EgoBU3e+s3soXyYtACMDSjJfMLBOk/00qPtgawwQ8=";
  };

  patches = [
    # Upstream found that setuptools-scm version 7 produces wrong versions,
    # but I don't know what that means and the build works fine.
    (fetchpatch {
      name = "revert-setuptools-scm-constraint.patch";
      url = "https://github.com/aio-libs/aiomysql/commit/fb85893635d7f9c0da3b1ff8c6d0fc436357633a.patch";
      hash = "sha256-xsxUydqfYYZ+AS/YyfKSuavyNgKUNySZWDVm6IkA+5o=";
      revert = true;
    })
  ];

  nativeBuildInputs = [
    setuptools-scm
    setuptools-scm-git-archive
    wheel
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
    maintainers = with maintainers; [ ];
  };
}
