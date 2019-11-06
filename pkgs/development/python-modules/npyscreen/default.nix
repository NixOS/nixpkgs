{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "npyscreen";
  version = "4.10.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0vhjwn0dan3zmffvh80dxb4x67jysvvf1imp6pk4dsfslpwy0bk2";
  };

  doCheck = false;

  meta = with lib; {
    homepage = "https://npyscreen.readthedocs.io/";
    description = "python widget library and application framework for programming terminal or console applications";
    license = licenses.bsd3;
    maintainers = with maintainers; [ "0x4A6F" ];
  };
}

