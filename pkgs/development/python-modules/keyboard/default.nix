{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "keyboard";
  version = "0.13.5";

  src = fetchFromGitHub {
    owner = "boppreh"; 
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "sha256-U4GWhPp28azBE3Jn9xpLxudOKx0PjnYO77EM2HsJ9lM=";
  };

  doCheck = false;

  meta = with lib; {
    description = "Hook and simulate keyboard events";
    homepage = "https://github.com/boppreh/keyboard";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
  };
}
