{ lib
, fetchPypi
, buildPythonPackage
, pbr
, pyserial
, pytest-flake8
, click
, markupsafe
, flask-cors
, pytestCheckHook
, requests
, enum34
, aprslib
, appdirs
, configparser
}:

buildPythonPackage rec {
  pname = "faraday";
  version = "0.0.1018.dev1438";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-hQu44nPIEzQNA96fU0r8lCeLF6FddLeL68C4eAvXqsk=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "enum34>=1.1.6" ""
  '';

  propagatedBuildInputs = [
    pbr
    pyserial
  ];

  checkInputs = [
    appdirs
    aprslib
    click
    configparser
    enum34
    flask-cors
    markupsafe
    pytestCheckHook
    pytest-flake8
    requests
  ];

  pythonImportsCheck = [ "faraday" ];

  meta = with lib; {
    description = "FaradayRF amateur radio open source software";
    homepage = "https://github.com/FaradayRF/Faraday-Software";
    license = licenses.gpl3;
    maintainers = with maintainers; [ onny ];
  };
}
