{ lib
, buildPythonPackage
, fetchPypi

# Test dependencies
, pytest, pytest-mock
}:

buildPythonPackage rec {
  pname = "RestrictedPython";
  version = "5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9ae16e500782b41bd1abefd8554ccb26330817bba9ce090d385aa226f1ca83e8";
  };

  #propagatedBuildInputs = [ xmltodict requests ifaddr ];

  checkInputs = [
    pytest pytest-mock
  ];

  checkPhase = ''
    pytest
  '';

  meta = {
    homepage = "https://github.com/zopefoundation/RestrictedPython";
    description = "A restricted execution environment for Python to run untrusted code";
    license = lib.licenses.zpl21;
    maintainers = with lib.maintainers; [ juaningan ];
  };
}
