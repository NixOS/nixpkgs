{ lib
, buildPythonPackage
, fetchFromGitHub
, future
, isPy3k
, pkgconfig
, psutil
, pytest
, pytestcov
, pytestrunner
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "python-lz4";
  version = "2.1.10";

  # get full repository inorder to run tests
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "02cadqfdmw4vc94px18dh4hcybpsa2lr6jz6j5phwc0jjaavh3wr";
  };

  buildInputs = [ setuptools_scm pkgconfig pytestrunner ];
  checkInputs = [ pytest pytestcov psutil ];
  propagatedBuildInputs = lib.optionals (!isPy3k) [ future ];

  # give a hint to setuptools_scm on package version
  preBuild = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION="v${version}"
  '';

  meta = {
     description = "LZ4 Bindings for Python";
     homepage = https://github.com/python-lz4/python-lz4;
     license = lib.licenses.bsd3;
     maintainers = with lib.maintainers; [ costrouc ];
  };
}
