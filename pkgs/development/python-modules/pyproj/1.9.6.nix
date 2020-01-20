{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, nose2
, cython
, proj ? null
}:

buildPythonPackage (rec {
  pname = "pyproj";
  version = "1.9.6";

  src = fetchFromGitHub {
    owner = "pyproj4";
    repo = "pyproj";
    rev = "v${version}rel";
    sha256 = "sha256:18v4h7jx4mcc0x2xy8y7dfjq9bzsyxs8hdb6v67cabvlz2njziqy";
  };

  buildInputs = [ cython ];

  checkInputs = [ nose2 ];

  checkPhase = ''
    runHook preCheck
    pushd unittest  # changing directory should ensure we're importing the global pyproj
    ${python.interpreter} test.py && ${python.interpreter} -c "import doctest, pyproj, sys; sys.exit(doctest.testmod(pyproj)[0])"
    popd
    runHook postCheck
  '';

  meta = {
    description = "Python interface to PROJ.4 library";
    homepage = https://github.com/pyproj4/pyproj;
    license = with lib.licenses; [ isc ];
  };
} // (if proj == null then {} else { PROJ_DIR = proj; }))
