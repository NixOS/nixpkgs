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
  version = "2.1.0";

  # get full repository inorder to run tests
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1vjfplj37jcw1mf8l810dv76dx0raia3ylgyfy7sfsb3g17brjq6";
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
     license = lib.licenses.bsd0;
     maintainers = with lib.maintainers; [ costrouc ];
  };
}
