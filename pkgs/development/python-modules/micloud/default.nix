{ lib
, buildPythonPackage
, fetchFromGitHub
, click
, pycryptodome
, requests
, tzlocal
}:

buildPythonPackage rec {
  pname = "micloud";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "Squachen";
    repo = "micloud";
    rev = "v_${version}";
    sha256 = "sha256-1qtOsEH+G5ASsRyVCa4U0WQ/9kDRn1WpPNkvuvWFovQ=";
  };

  propagatedBuildInputs = [
    click
    pycryptodome
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
