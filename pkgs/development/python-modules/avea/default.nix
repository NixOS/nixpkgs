{ lib
, buildPythonPackage
, fetchFromGitHub
, bluepy
}:

buildPythonPackage rec {
  pname = "avea";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "k0rventen";
    repo = pname;
    rev = "v${version}";
    sha256 = "13s21dnhbh10dd60xq2cklp5jyv46rpl3nivn1imcswp02930ihz";
  };

  propagatedBuildInputs = [
    bluepy
  ];

  # no tests are present
  doCheck = false;
  pythonImportsCheck = [ "avea" ];

  meta = with lib; {
    description = "Python module for interacting with Elgato's Avea bulb";
    homepage = "https://github.com/k0rventen/avea";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
