{ stdenv, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "hy";
  version = "0.18.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "04dfwm336gw61fmgwikvh0cnxk682p19b4w555wl5d7mlym4rwj2";
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
