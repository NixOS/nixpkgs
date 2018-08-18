{ stdenv, buildPythonPackage, fetchPypi
, python, pytest, sortedcontainers }:

buildPythonPackage rec {
  version = "2.1.0";
  pname = "intervaltree";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02w191m9zxkcjqr1kv2slxvhymwhj3jnsyy3a28b837pi15q19dc";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ sortedcontainers ];

  checkPhase = ''
    runHook preCheck
    rm build -rf
    ${python.interpreter} nix_run_setup test
    runHook postCheck
  '';

  meta = with stdenv.lib; {
    description = "Editable interval tree data structure for Python 2 and 3";
    homepage =  https://github.com/chaimleib/intervaltree;
    license = [ licenses.asl20 ];
    maintainers =  [ maintainers.bennofs ];
  };
}
