{ stdenv, fetchPypi
, buildPythonApplication, python, pythonAtLeast
, mock, nose, pyhamcrest
, glibcLocales, parse, parse-type, six
}:
buildPythonApplication rec {
  pname = "behave";
  version = "1.2.5";
  name = "${pname}-${version}";

  disabled = pythonAtLeast "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "81b731ac5187e31e4aad2594944fa914943683a9818320846d037c5ebd6d5d0b";
  };

  checkInputs = [ mock nose pyhamcrest ];
  buildInputs = [ glibcLocales ];
  propagatedBuildInputs = [ parse parse-type six ];

  postPatch = ''
    patchShebangs bin
  '';

  doCheck = true;

  checkPhase = ''
    export LANG="en_US.UTF-8"
    export LC_ALL="en_US.UTF-8"

    nosetests -x

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
