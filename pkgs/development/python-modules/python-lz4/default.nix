{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestrunner
, pytest
, psutil
, setuptools_scm
, pkgconfig
, isPy3k
, future
}:

buildPythonPackage rec {
  pname = "python-lz4";
  version = "2.1.2";

  # get full repository inorder to run tests
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1kzzdfkrq9nnlh0wssa6ccncvv0sk4wmhivhgyndjxz6d6przl5d";
  };

  buildInputs = [ setuptools_scm pkgconfig pytestrunner ];
  checkInputs = [ pytest psutil ];
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
