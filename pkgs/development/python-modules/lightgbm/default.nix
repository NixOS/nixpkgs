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
  version = "3.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5b9f31759ab4e94d9409deb03104c55b0a40058a6ccea804022046d926bc4904";
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
