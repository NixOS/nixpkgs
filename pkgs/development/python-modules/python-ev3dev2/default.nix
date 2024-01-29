{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, pillow
}:

buildPythonPackage rec {
  pname = "python-ev3dev2";
  version = "2.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ev3dev";
    repo = "ev3dev-lang-python";
    rev = version;
    sha256 = "XxsiQs3k5xKb+3RewARbvBbxaztdvdq3w5ZMgTq+kRc=";
    fetchSubmodules = true;
  };

  postPatch = ''
    echo "${version}" > RELEASE-VERSION
  '';

  propagatedBuildInputs = [ pillow ];

  checkPhase = ''
    chmod -R g+rw ./tests/fake-sys/devices/**/*
    ${python.interpreter} -W ignore::ResourceWarning tests/api_tests.py
  '';

  meta = with lib; {
    description = "Python language bindings for ev3dev";
    homepage = "https://github.com/ev3dev/ev3dev-lang-python";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ emilytrau ];
  };
}
