{ stdenv, buildPythonPackage, fetchPypi
, pytest, setuptools_scm }:

buildPythonPackage rec {
  pname = "apipkg";
  version = "1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "37228cda29411948b422fae072f57e31d3396d2ee1c9783775980ee9c9990af6";
  };

  nativeBuildInputs = [ setuptools_scm ];
  checkInputs = [ pytest ];

  # Fix pytest 4 support. See: https://github.com/pytest-dev/apipkg/issues/14
  postPatch = ''
    substituteInPlace "test_apipkg.py" \
      --replace "py.test.ensuretemp('test_apipkg')" "py.path.local('test_apipkg')"
  '';

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "Namespace control and lazy-import mechanism";
    homepage = "https://github.com/pytest-dev/apipkg";
    license = licenses.mit;
  };
}
