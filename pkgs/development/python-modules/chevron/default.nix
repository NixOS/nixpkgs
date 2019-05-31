{ lib
, buildPythonPackage
, fetchFromGitHub
, python
}:

buildPythonPackage rec {
  pname = "chevron";
  version = "0.13.1";

  # No tests available in the PyPI tarball
  src = fetchFromGitHub {
    owner = "noahmorrison";
    repo = "chevron";
    rev = "0.13.1";
    sha256 = "0l1ik8dvi6bgyb3ym0w4ii9dh25nzy0x4yawf4zbcyvvcb6af470";
  };

  checkPhase = ''
    ${python.interpreter} test_spec.py
  '';

  meta = with lib; {
    homepage = https://github.com/noahmorrison/chevron;
    description = "A python implementation of the mustache templating language";
    license = licenses.mit;
    maintainers = with maintainers; [ dhkl ];
  };
}
