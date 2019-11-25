{ lib
, buildPythonPackage
, fetchPypi
, tox
}:

buildPythonPackage rec {
  pname = "diskcache";
  version = "4.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bcee5a59f9c264e2809e58d01be6569a3bbb1e36a1e0fb83f7ef9b2075f95ce0";
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
