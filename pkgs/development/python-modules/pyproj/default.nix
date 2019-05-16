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
  version = "unstable-2018-11-13";

  src = fetchFromGitHub {
    owner = "jswhit";
    repo = pname;
    rev = "78540f5ff40da92160f80860416c91ee74b7643c";
    sha256 = "1vq5smxmpdjxialxxglsfh48wx8kaq9sc5mqqxn4fgv1r5n1m3n9";
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
    homepage = https://github.com/jswhit/pyproj;
    license = with lib.licenses; [ isc ];
  };
} // (if proj == null then {} else { PROJ_DIR = proj; }))
