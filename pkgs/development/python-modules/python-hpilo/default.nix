{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "python-hpilo";
  version = "4.4.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "seveas";
    repo = pname;
    rev = version;
    sha256 = "1dk5xswydw7nmn9hlna1xca1mzcas9qv2kmid5yx8kvk3hjqci9v";
  };

  # Most tests requires an actual iLO to run
  doCheck = false;
  pythonImportsCheck = [ "hpilo" ];

  meta = with lib; {
    description = "Python module to access the HP iLO XML interface";
    homepage = "https://seveas.github.io/python-hpilo/";
    license = with licenses; [ asl20 gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
