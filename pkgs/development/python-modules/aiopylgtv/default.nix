{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pythonOlder
, sqlitedict
, websockets
}:

buildPythonPackage rec {
  pname = "aiopylgtv";
  version = "0.4.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bendavid";
    repo = pname;
    rev = version;
    sha256 = "0x0xcnlz42arsp53zlq5wyv9pwif1in8j2pv48gh0pkdnz9s86b6";
  };

  propagatedBuildInputs = [
    numpy
    sqlitedict
    websockets
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "aiopylgtv" ];

  meta = with lib; {
    description = "Python library to control webOS based LG TV units";
    homepage = "https://github.com/bendavid/aiopylgtv";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
