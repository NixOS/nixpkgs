{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, pytestCheckHook
, httpretty
}:

buildPythonPackage rec {
  pname = "fixerio";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "amatellanes";
    repo = pname;
    rev = "v${version}";
    sha256 = "1k9ss5jc7sbpkjd2774vbmvljny0wm2lrc8155ha8yk2048jsaxk";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "requests==2.10.0" "requests"
  '';

  propagatedBuildInputs = [
    requests
  ];

  checkInputs = [
    httpretty
    pytestCheckHook
  ];

  pythonImportsCheck = [ "fixerio" ];

  meta = with lib; {
    description = "Python client for Fixer.io";
    longDescription = ''
      Fixer.io is a free JSON API for current and historical foreign
      exchange rates published by the European Central Bank.
    '';
    homepage = "https://github.com/amatellanes/fixerio";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
