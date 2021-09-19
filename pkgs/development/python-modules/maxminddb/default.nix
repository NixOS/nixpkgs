{ stdenv, lib, buildPythonPackage, pythonOlder, pythonAtLeast
, fetchPypi
, libmaxminddb
, ipaddress
, mock
, nose
}:

buildPythonPackage rec {
  version = "2.1.0";
  pname = "maxminddb";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c47b8acba98d03b8c762684d899623c257976f3eb0c9d557ff865d20cddc9d6b";
  };

  buildInputs = [ libmaxminddb ];

  propagatedBuildInputs = [ ipaddress ];

  checkInputs = [ nose mock ];

  # Tests are broken for macOS on python38
  doCheck = !(stdenv.isDarwin && pythonAtLeast "3.8");

  meta = with lib; {
    description = "Reader for the MaxMind DB format";
    homepage = "https://www.maxmind.com/en/home";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
