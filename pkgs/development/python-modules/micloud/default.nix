{ lib
, buildPythonPackage
, fetchFromGitHub
, click
, requests
, tzlocal
}:

buildPythonPackage rec {
  pname = "micloud";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "Squachen";
    repo = "micloud";
    rev = "v_${version}";
    sha256 = "01z1qfln6f7pnxb4ssmyygyamnfgh36fzgn85s8axdwy8wrch20x";
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
