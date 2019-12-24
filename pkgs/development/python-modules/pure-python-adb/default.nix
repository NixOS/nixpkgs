{ lib, buildPythonPackage, fetchFromGitHub, pytest}:

buildPythonPackage rec {
  pname = "pure-python-adb";
  version = "0.2.3-dev";

  src = fetchFromGitHub {
    owner = "Swind";
    repo = pname;
    rev = "v${version}";
    sha256 = "1xxn62q1qjywmvvnshilzmj139c2rrsa7sp2a4h3w2z0k6kjakhs";
  };

  propagatedBuildInputs = [ ];

  checkInputs = [ pytest ];

  # Other tests require networking
  checkPhase = ''
    pytest test/test_logging.py
    '';

  meta = with lib; {
    homepage = "https://github.com/Swind/pure-python-adb";
    description = "This is pure-python implementation of the ADB client";
    license = licenses.mit;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
