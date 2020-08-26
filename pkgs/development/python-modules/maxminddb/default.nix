{ stdenv, lib, buildPythonPackage, pythonOlder, pythonAtLeast
, fetchPypi
, libmaxminddb
, ipaddress
, mock
, nose
}:

buildPythonPackage rec {
  version = "2.0.2";
  pname = "maxminddb";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15z5557rn4yvrhnpdm9l4kczr151qv9px736hd361rlr2z98wpdr";
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
