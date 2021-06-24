{ lib, buildPythonPackage, fetchFromGitHub, pytestCheckHook, colorlog, lomond
, requests, isPy3k, requests-mock }:

buildPythonPackage rec {
  pname = "abodepy";
  version = "1.2.1";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "MisterWil";
    repo = pname;
    rev = "v${version}";
    sha256 = "0n8gczsml6y6anin1zi8j33sjk1bv9ka02zxpksn2fi1v1h0smap";
  };

  propagatedBuildInputs = [ colorlog lomond requests ];
  checkInputs = [ pytestCheckHook requests-mock ];

  meta = with lib; {
    homepage = "https://github.com/MisterWil/abodepy";
    description = "An Abode alarm Python library running on Python 3";
    license = licenses.mit;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
