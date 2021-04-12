{ lib
, aiohttp
, xmltodict
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "omnilogic";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "djtimca";
    repo = "omnilogic-api";
    rev = "v${version}";
    sha256 = "19pmbykq0mckk23aj33xbhg3gjx557xy9a481mp6pkmihf2lsc8z";
  };

  propagatedBuildInputs = [
    aiohttp
    xmltodict
  ];

  postPatch = ''
    # Is not used but still present in setup.py
    substituteInPlace setup.py --replace "'config'," ""
  '';

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "omnilogic" ];

  meta = with lib; {
    description = "Python interface for the Hayward Omnilogic pool control system";
    homepage = "https://github.com/djtimca/omnilogic-api";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
