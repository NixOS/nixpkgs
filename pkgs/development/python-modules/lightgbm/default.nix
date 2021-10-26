{ lib, stdenv
, buildPythonPackage
, fetchPypi
, cmake
, numpy
, scipy
, scikit-learn
, llvmPackages ? null
}:

buildPythonPackage rec {
  pname = "lightgbm";
  version = "3.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "107ae7babbbda2c2f0e07484f0c53cdeb455e9219235f79dc4e1685d7541e505";
  };

  nativeBuildInputs = [
    cmake
  ];

  dontUseCmakeConfigure = true;

  buildInputs = lib.optional stdenv.cc.isClang [ llvmPackages.openmp ];
  propagatedBuildInputs = [
    numpy
    scipy
    scikit-learn
  ];

  postConfigure = ''
    export HOME=$(mktemp -d)
  '';

  # The pypi package doesn't distribute the tests from the GitHub
  # repository. It contains c++ tests which don't seem to wired up to
  # `make check`.
  doCheck = false;
  pythonImportsCheck = [ "lightgbm" ];

  meta = with lib; {
    description = "A fast, distributed, high performance gradient boosting (GBDT, GBRT, GBM or MART) framework";
    homepage = "https://github.com/Microsoft/LightGBM";
    license = licenses.mit;
    maintainers = with maintainers; [ teh costrouc ];
  };
}
