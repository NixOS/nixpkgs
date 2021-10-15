{ lib
, buildPythonPackage
, fetchPypi
, marshmallow
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "faraday-agent-parameters-types";
  version = "1.0.1";

  src = fetchPypi {
    pname = "faraday_agent_parameters_types";
    inherit version;
    sha256 = "0q2cngxgkvl74mhkibvdsvjjrdfd7flxd6a4776wmxkkn0brzw66";
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
