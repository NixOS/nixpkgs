{ lib
, buildPythonPackage
, fetchFromGitHub
, click
, requests
, tzlocal
}:

buildPythonPackage rec {
  pname = "micloud";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "Squachen";
    repo = "micloud";
    rev = "v_${version}";
    sha256 = "0267zyr79nfb5f9rwdwq3ym258yrpxx1b71xiqmszyz5s83mcixm";
  };

  propagatedBuildInputs = [
    click
    requests
    tzlocal
  ];

  # tests require credentials
  doCheck = false;

  pythonImportsCheck = [ "micloud" ];

  meta = with lib; {
    description = "Xiaomi cloud connect library";
    homepage = "https://github.com/Squachen/micloud";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
