{ stdenv, lib, fetchFromGitHub, buildPythonPackage, hypothesis, pytestCheckHook
, pythonOlder }:

buildPythonPackage rec {
  pname = "flatbencode";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "acatton";
    repo = pname;
    rev = "v${version}";
    sha256 = "1vvyh9mwzjm8il41qm3gl1bssg48n7kl0p1h4nhaq81wa7ik1znp";
  };

  checkInputs = [ pytestCheckHook hypothesis ];

  disabled = pythonOlder "3.4";

  meta = with lib; {
    description =
      "Fast, safe and non-recursive implementation of Bittorrent bencoding for Python 3";
    homepage = "https://github.com/acatton/flatbencode";
    license = licenses.mit;
    maintainers = with maintainers; [ synthetica ];
  };
}
