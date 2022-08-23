{ lib
, pythonOlder
, buildPythonPackage
, fetchFromGitHub
, python3-application
, python3-eventlib
, python3-gnutls
, twisted
}:

buildPythonPackage rec {
  pname = "python3-msrplib";
  version = "0.21.0";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "AGProjects";
    repo = pname;
    rev = version;
    sha256 = "sha256-rjkg6iRvnokNikd2UAyngKuS2tkeKmGdu4Uvw5lvcys=";
  };

  propagatedBuildInputs = [
    python3-application
    python3-eventlib
    python3-gnutls
    twisted
  ];

  pythonImportsCheck = [ "msrplib" ];

  meta = with lib; {
    description = "MSRP (RFC4975) client library";
    homepage = "https://github.com/AGProjects/python3-msrplib";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ yureien ];
  };
}
