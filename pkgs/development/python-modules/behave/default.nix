{ stdenv, fetchPypi
, buildPythonApplication, python, pythonOlder
, mock, nose, pathpy, pyhamcrest, pytest
, glibcLocales, parse, parse-type, six
, traceback2
}:
buildPythonApplication rec {
  pname = "behave";
  version = "1.2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "11hsz365qglvpp1m1w16239c3kiw15lw7adha49lqaakm8kj6rmr";
  };

  checkInputs = [ mock nose pathpy pyhamcrest pytest ];
  buildInputs = [ glibcLocales ];
  propagatedBuildInputs = [ parse parse-type six ] ++ stdenv.lib.optional (pythonOlder "3.0") traceback2;

  postPatch = ''
    patchShebangs bin
  '';

  doCheck = true;

  checkPhase = ''
    export LANG="en_US.UTF-8"
    export LC_ALL="en_US.UTF-8"

    pytest test tests

    ${python.interpreter} bin/behave -f progress3 --stop --tags='~@xfail' features/
    ${python.interpreter} bin/behave -f progress3 --stop --tags='~@xfail' tools/test-features/
    ${python.interpreter} bin/behave -f progress3 --stop --tags='~@xfail' issue.features/
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/behave/behave;
    description = "behaviour-driven development, Python style";
    license = licenses.bsd2;
    maintainers = with maintainers; [ alunduil ];
  };
}
