{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, requests
, urllib3
, importlib-metadata
}:

buildPythonPackage rec {
  pname = "frameioclient";
  version = "0.7.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3ec2dd0be305a6249f365b23210ec8f554288752899bceae82c133264c720092";
  };

  propagatedBuildInputs = [
    requests
    urllib3 ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

    meta = with lib; {
      description = "Python library for to interface with frame.io's restful api";
      homepage = "https://github.com/Frameio/python-frameio-client";
      license = licenses.bsd3;
      platforms = platforms.all;
      maintainers = with maintainers; [ drfacepalm ];
    };
}
