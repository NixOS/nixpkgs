{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  paho-mqtt,
  requests,
  urllib3,
}:

buildPythonPackage rec {
  pname = "pyworxcloud";
  version = "4.1.46";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MTrab";
    repo = "pyworxcloud";
    tag = "v${version}";
    hash = "sha256-JRmAARfmGRWdUj4J2CqUaRd+S9itZgCxqbRl78Iub+o=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    paho-mqtt
    requests
    urllib3
  ];

  pythonImportsCheck = [ "pyworxcloud" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Module for integrating with Worx Cloud devices";
    homepage = "https://github.com/MTrab/pyworxcloud";
    changelog = "https://github.com/MTrab/pyworxcloud/releases/tag/${src.tag}";
    license = with lib.licenses; [
      gpl3Only
      mit
    ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
