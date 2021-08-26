{ lib
, fetchPypi
, buildPythonPackage
, numpy
, scipy
, cython
, matplotlib
, scikit-learn
, cupy
, pymanopt
, autograd
, pytestCheckHook
, enableDimensionalityReduction ? false
, enableGPU ? false
}:

buildPythonPackage rec {
  pname = "pot";
  version = "0.7.0";

  src = fetchPypi {
    pname = "POT";
    inherit version;
    sha256 = "01mdsiv8rlgqzvm3bds9aj49khnn33i523c2cqqrl10zg742pb6l";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov-report= --cov=ot" ""
  '';

  nativeBuildInputs = [ numpy cython ];
  propagatedBuildInputs = [ numpy scipy ]
    ++ lib.optionals enableGPU [ cupy ]
    ++ lib.optionals enableDimensionalityReduction [ pymanopt autograd ];
  checkInputs = [ matplotlib scikit-learn pytestCheckHook ];

  # To prevent importing of an incomplete package from the build directory
  # instead of nix store (`ot` is the top-level package name).
  preCheck = ''
    rm -r ot
  '';

  # GPU tests are always skipped because of sandboxing
  disabledTests = [ "warnings" ];

  pythonImportsCheck = [ "ot" "ot.lp" ];

  meta = {
    description = "Python Optimal Transport Library";
    homepage = "https://pythonot.github.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yl3dy ];
  };
}
