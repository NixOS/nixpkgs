{ lib
, buildPythonPackage
, fetchFromGitHub
, future
, isPy3k
, pkgconfig
, psutil
, pytest
, pytest-cov
, pytest-runner
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "python-lz4";
  version = "3.1.10";

  # get full repository inorder to run tests
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "0a4gic8xh3simkk5k8302rxwf765pr6y63k3js79mkl983vpxcim";
  };

  nativeBuildInputs = [ setuptools-scm pkgconfig pytest-runner ];
  checkInputs = [ pytest pytest-cov psutil ];
  propagatedBuildInputs = lib.optionals (!isPy3k) [ future ];

  # give a hint to setuptools-scm on package version
  preBuild = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION="v${version}"
  '';

  meta = {
     description = "LZ4 Bindings for Python";
     homepage = "https://github.com/python-lz4/python-lz4";
     license = lib.licenses.bsd3;
     maintainers = with lib.maintainers; [ costrouc ];
  };
}
