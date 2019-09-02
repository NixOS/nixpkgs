{ stdenv, buildPythonPackage, fetchPypi
, pytest_3, setuptools_scm }:

buildPythonPackage rec {
  pname = "apipkg";
  version = "1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "37228cda29411948b422fae072f57e31d3396d2ee1c9783775980ee9c9990af6";
  };

  nativeBuildInputs = [ setuptools_scm ];
  checkInputs = [ pytest_3 ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "Namespace control and lazy-import mechanism";
    homepage = https://bitbucket.org/hpk42/apipkg;
    license = licenses.mit;
  };
}
