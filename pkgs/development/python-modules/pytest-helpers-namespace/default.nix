{ buildPythonPackage
, fetchFromGitHub
, pytest
, lib
}:

buildPythonPackage rec {
  pname = "pytest-helpers-namespace";
  version = "2021.3.24";

  src = fetchFromGitHub {
    owner = "saltstack";
    repo = pname;
    rev = version;
    sha256 = "0ikwiwp9ycgg7px78nxdkqvg7j97krb6vzqlb8fq8fvbwrj4q4v2";
  };

  buildInputs = [ pytest ];

  checkInputs = [ pytest ];

  checkPhase = ''
    pytest
  '';

  # The tests fail with newest pytest. They passed with pytest_3, which no longer exists
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/saltstack/pytest-helpers-namespace";
    description = "PyTest Helpers Namespace";
    license = licenses.asl20;
    maintainers = [ maintainers.kiwi ];
  };
}
