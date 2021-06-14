{ lib
, buildPythonPackage
, isPy27
, fetchFromGitHub
, freezegun
, pytest
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-freezegun";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "ktosiek";
    repo = "pytest-freezegun";
    rev = version;
    sha256 = "10c4pbh03b4s1q8cjd75lr0fvyf9id0zmdk29566qqsmaz28npas";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    freezegun
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Wrap tests with fixtures in freeze_time";
    homepage = "https://github.com/ktosiek/pytest-freezegun";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
