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
  version = "2024.9.16";
  pyproject = true;

  src = fetchPypi {
    pname = "scikit_fmm";
    inherit version;
    hash = "sha256-q6hqteXv600iH7xpCKHgRLkJYSpy9hIf/QnlsYI+jh4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "oldest-supported-numpy" "numpy"
  '';

  build-system = [ meson-python ];

  dependencies = [ numpy ];

  checkPhase = ''
    mkdir testdir; cd testdir
    ${python.interpreter} -c "import skfmm, sys; sys.exit(skfmm.test())"
  '';

  meta = with lib; {
    description = "Python extension module which implements the fast marching method";
    homepage = "https://github.com/scikit-fmm/scikit-fmm";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
