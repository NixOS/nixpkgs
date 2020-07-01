{ stdenv, buildPythonPackage, fetchFromGitHub, python, robotframework, selenium, mockito, robotstatuschecker, approvaltests }:

buildPythonPackage rec {
  version = "3.3.1";
  pname = "robotframework-seleniumlibrary";

  # no tests included in PyPI tarball
  src = fetchFromGitHub {
    owner = "robotframework";
    repo = "SeleniumLibrary";
    rev = "v${version}";
    sha256 = "0dabc5dwx0pwsyiy74d7wj97k72yl28a17sasjzrdq819pyc3dvq";
  };

  propagatedBuildInputs = [ robotframework selenium ];
  checkInputs = [ mockito robotstatuschecker approvaltests ];

  # Only execute Unit Tests. Acceptance Tests require headlesschrome, currently
  # not available in nixpkgs
  checkPhase = ''
    ${python.interpreter} utest/run.py
  '';

  meta = with stdenv.lib; {
    description = "Web testing library for Robot Framework";
    homepage = "https://github.com/robotframework/SeleniumLibrary";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
