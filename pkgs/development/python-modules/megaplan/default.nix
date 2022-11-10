{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "megaplan";
  version = "1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Cq1oqZwxtfEuVsSjMLLaoADRbAeCiiPz9uhy1f3XE6Q=";
  };

  pythonImprotsCheck = [ "megaplan" ];

  meta = with lib; {
    description = "Python interface to megaplan.ru API";
    homepage = "https://pypi.org/project/megaplan";
    license = licenses.gpl3;
    maintainers = with maintainers; [ onny ];
  };
}
