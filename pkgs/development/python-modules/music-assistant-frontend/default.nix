{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "music_assistant_frontend";
  version = "2.6.3";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    dist = "py3";
    python = "py3";
    hash = "sha256-A4swDf6ojywTExsGn1V5ra7BK55p439qiKnrDpHOZMI=";
  };

  pythonImportsCheck = [ "music_assistant_frontend" ];

  meta = with lib; {
    description = "Frontend module for Music Assistant";
    homepage = "https://github.com/music-assistant/frontend";
    changelog = "https://github.com/music-assistant/frontend/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ mindstorms6 ];
  };
}
