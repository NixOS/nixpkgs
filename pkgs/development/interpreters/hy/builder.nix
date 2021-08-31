{ lib
, python3Packages
, hyDefinedPythonPackages /* Packages like with python.withPackages */
, ...
}:
python3Packages.buildPythonApplication rec {
  pname = "hy";
  version = "1.0a1";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-lCrbvbkeutSNmvvn/eHpTnJwPb5aEH7hWTXYSE+AJmU=";
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
  ] ++ (hyDefinedPythonPackages python3Packages);

  # Hy does not include tests in the source distribution from PyPI, so only test executable.
  checkPhase = ''
    $out/bin/hy --help > /dev/null
  '';

  meta = with lib; {
    description = "A LISP dialect embedded in Python";
    homepage = "https://hylang.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ nixy mazurel ];
    platforms = platforms.all;
  };
}
