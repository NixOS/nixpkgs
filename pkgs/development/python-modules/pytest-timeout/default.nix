{ buildPythonPackage
, fetchPypi
, fetchpatch
, lib
, pexpect
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-timeout";
  version = "1.3.2";

  # remove after version 1.3.1
  patches = [
    (fetchpatch {
      name = "fix-installation-27-3-with-encoding-issue.patch";
      url = "https://bitbucket.org/pytest-dev/pytest-timeout/commits/9de81d3fc57a71a36d418d4aa181c241a7c5350f/raw";
      sha256 = "0g081j6iyc9825f63ssmmi40rkcgk4p9vvhy9g0lqd0gc6xzwa2p";
    })
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1117fc0536e1638862917efbdc0895e6b62fa61e6cf4f39bb655686af7af9627";
  };

  buildInputs = [ pytest ];
  checkInputs = [ pytest pexpect ];
  checkPhase = ''pytest -ra'';

  meta = with lib;{
    description = "py.test plugin to abort hanging tests";
    homepage = https://bitbucket.org/pytest-dev/pytest-timeout/;
    license = licenses.mit;
    maintainers = with maintainers; [ makefu costrouc ];
  };
}
