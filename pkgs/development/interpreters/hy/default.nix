{ stdenv, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "hy";
  version = "0.19.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "05k05qmiiysiwdc05sxmanwhv1crfwbb3l8swxfisbzbvmv1snis";
  };

  checkInputs = with python3Packages; [ flake8 pytest ];

  propagatedBuildInputs = with python3Packages; [
    appdirs
    astor
    clint
    colorama
    fastentrypoints
    funcparserlib
    rply
    pygments
  ];

  # Hy does not include tests in the source distribution from PyPI, so only test executable.
  checkPhase = ''
    $out/bin/hy --help > /dev/null
  '';

  meta = with stdenv.lib; {
    description = "A LISP dialect embedded in Python";
    homepage = "http://hylang.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ nixy ];
    platforms = platforms.all;
  };
}
