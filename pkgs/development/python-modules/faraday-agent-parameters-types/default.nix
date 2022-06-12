{ lib
, buildPythonPackage
, fetchPypi
, marshmallow
, packaging
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "faraday-agent-parameters-types";
  version = "1.0.3";

  src = fetchPypi {
    pname = "faraday_agent_parameters_types";
    inherit version;
    sha256 = "6155669db477c3330c0850814eabe231bbbadf9d2ec57b4f734994f76eaee0e7";
  };

  propagatedBuildInputs = [
    marshmallow
    packaging
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner",' ""
  '';

  pythonImportsCheck = [
    "faraday_agent_parameters_types"
    "faraday_agent_parameters_types.utils"
  ];

  meta = with lib; {
    description = "Collection of Faraday agent parameters types";
    homepage = "https://github.com/infobyte/faraday_agent_parameters_types";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
