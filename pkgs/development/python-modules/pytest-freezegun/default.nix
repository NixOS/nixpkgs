{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
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

  patches = [
    (fetchpatch {
      # https://github.com/ktosiek/pytest-freezegun/pull/38
      name = "pytest-freezegun-drop-distutils.patch";
      url = "https://github.com/ktosiek/pytest-freezegun/commit/03d7107a877e8f07617f931a379f567d89060085.patch";
      hash = "sha256-/7GTQdidVbE2LT5hwxjEc2dr+aWr6TX1131U4KMQhns=";
    })
  ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    freezegun
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Wrap tests with fixtures in freeze_time";
    homepage = "https://github.com/ktosiek/pytest-freezegun";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
