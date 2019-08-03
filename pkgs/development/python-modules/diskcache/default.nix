{ lib
, buildPythonPackage
, fetchPypi
, tox
}:

buildPythonPackage rec {
  pname = "diskcache";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7c20b58ed07d03bbfba793f823d1fc27a61e590371fe6011fa1319a25c028cd1";
  };

  checkInputs = [
    tox
  ];

  meta = with lib; {
    description = "Disk and file backed persistent cache";
    homepage = https://www.grantjenks.com/docs/diskcache/;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
