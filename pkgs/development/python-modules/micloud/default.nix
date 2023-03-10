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
  version = "0.6";

  src = fetchFromGitHub {
    owner = "Squachen";
    repo = "micloud";
    rev = "v_${version}";
    hash = "sha256-IsNXFs1N+rKwqve2Pjp+wRTZCxHF4acEo6KyhsSKuqI=";
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
