{ stdenv, fetchFromGitHub, buildPythonPackage,
  tkinter, xmlschema, docutils, pygments, pyyaml, enum34, enum-compat, pillow, lxml,
  python }:

buildPythonPackage rec {
  pname = "robotframework";
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "robotframework";
    repo = pname;
    rev = "v${version}";
    sha256 = "0drsw2jm6qlx9j15lj71l5bwgmsqa36pcqq61rk02xy6zvsp68dd";
  };

  propagatedBuildInputs = [ tkinter xmlschema docutils pygments pyyaml enum34 enum-compat pillow lxml ];

  patches = [ ./unit-testing.patch ];

  checkPhase = ''
    # Unit tests (quick)
    ${python.interpreter} utest/run.py

    # Acceptance tests (these take a long time)
    # ${python.interpreter} atest/run.py ${python.interpreter} --exclude no-ci atest/robot
  '';

  meta = with stdenv.lib; {
    description = "Generic test automation framework";
    homepage = "https://robotframework.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ bjornfor ];
  };
}
