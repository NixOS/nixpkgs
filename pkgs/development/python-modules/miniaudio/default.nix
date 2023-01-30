{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, cffi
, pytestCheckHook
, AudioToolbox
, CoreAudio
}:

buildPythonPackage rec {
  pname = "miniaudio";
  version = "1.55";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "irmen";
    repo = "pyminiaudio";
    rev = "refs/tags/v${version}";
    hash = "sha256-na8pnYIoawICbsVquzlmfYZtIagsVBudFOKJ62jSTGM=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    AudioToolbox
    CoreAudio
  ];

  propagatedNativeBuildInputs = [ cffi ];
  propagatedBuildInputs = [ cffi ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "miniaudio" ];

  meta = with lib; {
    description = "Python bindings for the miniaudio library and its decoders";
    homepage = "https://github.com/irmen/pyminiaudio";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
