{ stdenv, lib, buildPythonPackage, fetchFromGitHub, python, robotframework, selenium, mockito, robotstatuschecker, approvaltests }:

buildPythonPackage rec {
  version = "6.0.0";
  pname = "robotframework-seleniumlibrary";

  # no tests included in PyPI tarball
  src = fetchFromGitHub {
    owner = "robotframework";
    repo = "SeleniumLibrary";
    rev = "v${version}";
    sha256 = "1rjzz6mrx4zavcck2ry8269rf3dkvvs1qfa9ra7dkppbarrjin3f";
  };

  propagatedBuildInputs = [ robotframework selenium ];
  checkInputs = [ mockito robotstatuschecker approvaltests ];

  # Only execute Unit Tests. Acceptance Tests require headlesschrome, currently
  # not available in nixpkgs
  checkPhase = ''
    ${python.interpreter} utest/run.py
  '';

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "Web testing library for Robot Framework";
    homepage = "https://github.com/robotframework/SeleniumLibrary";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
