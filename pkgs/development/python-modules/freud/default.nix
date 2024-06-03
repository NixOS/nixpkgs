{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, cmake
, cython
, oldest-supported-numpy
, scikit-build
, setuptools
, tbb
, numpy
, rowan
, scipy
, pytest
, gsd
, matplotlib
, sympy
}:

buildPythonPackage rec {
  pname = "freud";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "glotzerlab";
    repo = "freud";
    rev = "v${version}";
    hash = "sha256-aKh2Gub1vU/wzvWkCl8yzlIswp8CtR975USiCr6ijUI=";
    fetchSubmodules = true;
  };
  # Because we prefer to not `leaveDotGit`, we need to fool upstream into
  # thinking we left the .git files in the submodules, so cmake won't think we
  # didn't initialize them. Upstream doesn't support using the system wide
  # installed version of these libraries, and it's probably aint's worth the
  # hassle, because upstream also doesn't distribute all of these dependencies'
  # libraries, and probably it uses only what it needs.
  preConfigure = ''
    touch extern/{voro++,fsph,Eigen}/.git
  '';

  nativeBuildInputs = [
    cmake
    cython
    oldest-supported-numpy
    scikit-build
    setuptools
  ];
  dontUseCmakeConfigure = true;
  buildInputs = [
    tbb
  ];

  propagatedBuildInputs = [
    numpy
    rowan
    scipy
  ];

  nativeCheckInputs = [
    # Encountering circular ImportError issues with pytestCheckHook, see also:
    # https://github.com/NixOS/nixpkgs/issues/255262
    pytest
    gsd
    matplotlib
    sympy
  ];
  checkPhase = ''
    runHook preCheck

    pytest

    runHook postCheck
  '';
  # Some tests fail on aarch64. If we could have used pytestCheckHook, we would
  # have disabled only the tests that fail with the disabledTests attribute.
  # But that is not possible unfortunately. See upstream report for the
  # failure: https://github.com/glotzerlab/freud/issues/961
  doCheck = !stdenv.isAarch64;

  pythonImportsCheck = [ "freud" ];

  meta = with lib; {
    description = "Powerful, efficient particle trajectory analysis in scientific Python";
    homepage = "https://github.com/glotzerlab/freud";
    changelog = "https://github.com/glotzerlab/freud/blob/${src.rev}/ChangeLog.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ doronbehar ];
  };
}
