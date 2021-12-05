{ lib, buildPythonPackage, pythonOlder, fetchFromGitHub, pytest, pytestCheckHook
, docutils, pygments }:

buildPythonPackage rec {
  pname = "pytest-subprocess";
  version = "1.3.2";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "aklajnert";
    repo = "pytest-subprocess";
    rev = version;
    sha256 = "sha256-auPpqoPeYxmkWTVbbKhEZI6gJGH9Pf1D9YLkuD3FaX0=";
  };

  buildInputs = [ pytest ];

  checkInputs = [ pytestCheckHook docutils pygments ];

  meta = with lib; {
    description = "A plugin to fake subprocess for pytest";
    homepage = "https://github.com/aklajnert/pytest-subprocess";
    changelog =
      "https://github.com/aklajnert/pytest-subprocess/blob/${version}/HISTORY.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
