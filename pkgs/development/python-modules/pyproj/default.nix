{ lib
, buildPythonPackage
, fetchPypi
, python
, nose2
, proj ? null
}:

buildPythonPackage (rec {
  pname = "pyproj";
  version = "1.9.5.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "53fa54c8fa8a1dfcd6af4bf09ce1aae5d4d949da63b90570ac5ec849efaf3ea8";
  };

  buildInputs = [ nose2 ];

  checkPhase = ''
    runHook preCheck
    pushd unittest  # changing directory should ensure we're importing the global pyproj
    ${python.interpreter} test.py && ${python.interpreter} -c "import doctest, pyproj, sys; sys.exit(doctest.testmod(pyproj)[0])"
    popd
    runHook postCheck
  '';

  meta = {
    description = "Python interface to PROJ.4 library";
    homepage = http://github.com/jswhit/pyproj;
    license = with lib.licenses; [ isc ];
  };
} // (if proj == null then {} else { PROJ_DIR = proj; }))
