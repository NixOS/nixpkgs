{
  buildPythonPackage,
  fetchPypi,
  lib,
  matplotlib,
  numpy,
  pyaudio,
  pydub,
  pythonOlder,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "auditok";
  version = "0.1.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version;
    pname = "auditok";
    hash = "sha256-HNsw9VLP7XEgs8E2X6p7ygDM47AwWxMYjptipknFig4=";
  };

  propagatedBuildInputs = [
    matplotlib
    numpy
    pyaudio
    pydub
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [
    "-s"
    "tests"
  ];

  pythonImportsCheck = [ "auditok" ];

  # The most recent version is 0.2.0, but the only dependent package is
  # ffsubsync, which is pinned at 0.1.5.
  passthru.skipBulkUpdate = true;

  meta = with lib; {
    description = "Audio Activity Detection tool that can process online data as well as audio files";
    mainProgram = "auditok";
    homepage = "https://github.com/amsehili/auditok/";
    changelog = "https://github.com/amsehili/auditok/blob/v${version}/CHANGELOG";
    license = licenses.mit;
    maintainers = with maintainers; [ Benjamin-L ];
  };
}
