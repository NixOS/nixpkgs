{ lib, fetchPypi, buildPythonPackage, packaging, sip_5 }:

buildPythonPackage rec {
  pname = "pyqt-builder";
  version = "1.6.0";

  src = fetchPypi {
    pname = "PyQt-builder";
    inherit version;
    sha256 = "0g51yak53zzjs4gpq65i01cmpz7w8cjny9wfyxlgr2vi0wag107v";
  };

  propagatedBuildInputs = [ packaging sip_5 ];

  pythonImportsCheck = [ "pyqtbuild" ];

  # There aren't tests
  doCheck = false;

  meta = with lib; {
    description = "PEP 517 compliant build system for PyQt";
    homepage = "https://pypi.org/project/PyQt-builder/";
    license = licenses.gpl3Only;
  };
}
