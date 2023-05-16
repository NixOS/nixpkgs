{ lib
, stdenv
<<<<<<< HEAD
, buildPythonPackage
, cvxopt
, ecos
, fetchPypi
, numpy
, osqp
, pytestCheckHook
, pythonOlder
, scipy
, scs
, setuptools
, wheel
, useOpenmp ? (!stdenv.isDarwin)
=======
, pythonOlder
, buildPythonPackage
, fetchPypi
, cvxopt
, ecos
, numpy
, osqp
, scipy
, scs
, setuptools
, useOpenmp ? (!stdenv.isDarwin)
  # Check inputs
, pytestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "cvxpy";
<<<<<<< HEAD
  version = "1.3.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-C2heUEDxmfPXA/MPXSLR+GVZdiNFUVPR3ddwJFrvCXU=";
  };

  # we need to patch out numpy version caps from upstream
  postPatch = ''
    sed -i 's/\(numpy>=[0-9.]*\),<[0-9.]*;/\1;/g' pyproject.toml
  '';

  nativeBuildInputs = [
    setuptools
    wheel
  ];

=======
  version = "1.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Zszme9xjW5spBmUQR0OSwM/A2V24rdpAENyM3Y4EYlA=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "setuptools <= 64.0.2" "setuptools"
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    cvxopt
    ecos
    numpy
    osqp
    scipy
    scs
    setuptools
  ];

<<<<<<< HEAD
  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Required flags from https://github.com/cvxpy/cvxpy/releases/tag/v1.1.11
=======
  # Required flags from https://github.com/cvxgrp/cvxpy/releases/tag/v1.1.11
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  preBuild = lib.optionalString useOpenmp ''
    export CFLAGS="-fopenmp"
    export LDFLAGS="-lgomp"
  '';

<<<<<<< HEAD
  pytestFlagsArray = [
    "cvxpy"
  ];

  disabledTests = [
   # Disable the slowest benchmarking tests, cuts test time in half
=======
  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "./cvxpy" ];

   # Disable the slowest benchmarking tests, cuts test time in half
  disabledTests = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    "test_tv_inpainting"
    "test_diffcp_sdp_example"
    "test_huber"
    "test_partial_problem"
  ] ++ lib.optionals stdenv.isAarch64 [
<<<<<<< HEAD
    "test_ecos_bb_mi_lp_2" # https://github.com/cvxpy/cvxpy/issues/1241#issuecomment-780912155
  ];

  pythonImportsCheck = [
    "cvxpy"
  ];
=======
    "test_ecos_bb_mi_lp_2" # https://github.com/cvxgrp/cvxpy/issues/1241#issuecomment-780912155
  ];

  pythonImportsCheck = [ "cvxpy" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A domain-specific language for modeling convex optimization problems in Python";
    homepage = "https://www.cvxpy.org/";
<<<<<<< HEAD
    downloadPage = "https://github.com/cvxpy/cvxpy//releases";
    changelog = "https://github.com/cvxpy/cvxpy/releases/tag/v${version}";
=======
    downloadPage = "https://github.com/cvxgrp/cvxpy/releases";
    changelog = "https://github.com/cvxgrp/cvxpy/releases/tag/v${version}";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
