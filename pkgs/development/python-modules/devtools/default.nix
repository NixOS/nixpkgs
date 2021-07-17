{ buildPythonPackage, pythonOlder, fetchFromGitHub, lib, pygments
, pytestCheckHook, pytest-mock }:

buildPythonPackage rec {
  pname = "devtools";
  version = "0.6.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "samuelcolvin";
    repo = "python-${pname}";
    rev = "v${version}";
    sha256 = "0s1d2jwijini7y1a3318yhb98mh1mw4pzlfx2zck3a8nqw984ki3";
  };

  propagatedBuildInputs = [ pygments ];

  checkInputs = [ pytestCheckHook pytest-mock ];

  pythonImportsCheck = [ "devtools" ];

  meta = with lib; {
    description = "Python's missing debug print command and other development tools";
    homepage = "https://python-devtools.helpmanual.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ jdahm ];
  };
}
