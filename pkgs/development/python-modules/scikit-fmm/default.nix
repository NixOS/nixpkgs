{
  lib,
  buildPythonPackage,
  fetchPypi,
  meson-python,
  numpy,
  python,
}:

buildPythonPackage rec {
  pname = "scikit-fmm";
  version = "2025.1.29";
  pyproject = true;

  src = fetchPypi {
    pname = "scikit_fmm";
    inherit version;
    hash = "sha256-7gTKuObCAahEjfmIL8Azbby3nxJPPh4rjb4x1O4xBQw=";
  };

  build-system = [ meson-python ];

  dependencies = [ numpy ];

  checkPhase = ''
    runHook preCheck
    # "Do not run the tests from the source directory"
    mkdir testdir; cd testdir
    (set -x
      ${python.interpreter} -c "import skfmm, sys; sys.exit(skfmm.test())"
    )
    runHook postCheck
  '';

  meta = with lib; {
    description = "Python extension module which implements the fast marching method";
    homepage = "https://github.com/scikit-fmm/scikit-fmm";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
