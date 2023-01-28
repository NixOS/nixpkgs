{ lib, buildPythonPackage, fetchFromGitHub, pytestCheckHook, colorlog, lomond
, requests, isPy3k, requests-mock }:

buildPythonPackage rec {
  pname = "abodepy";
  version = "1.2.2";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "MisterWil";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-GrvNCgWGGBbUUONwS18csh4/A0MMkSk5Z6LlDhlQqok=";
  };

  propagatedBuildInputs = [ colorlog lomond requests ];
  nativeCheckInputs = [ pytestCheckHook requests-mock ];

  meta = with lib; {
    homepage = "https://github.com/MisterWil/abodepy";
    description = "An Abode alarm Python library running on Python 3";
    license = licenses.mit;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
