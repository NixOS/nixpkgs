{ lib
, buildPythonPackage
, fetchPypi
, marshmallow
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "faraday-agent-parameters-types";
  version = "1.0.2";

  src = fetchPypi {
    pname = "faraday_agent_parameters_types";
    inherit version;
    sha256 = "sha256-zH/ZkqL+kL3J1o7dhB4WYy2tbofFZm+kxEGn5+nRgjc=";
  };

  propagatedBuildInputs = [
    marshmallow
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner",' ""
  '';

  pythonImportsCheck = [ "faraday_agent_parameters_types" ];

  meta = with lib; {
    description = "Collection of Faraday agent parameters types";
    homepage = "https://github.com/infobyte/faraday_agent_parameters_types";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
