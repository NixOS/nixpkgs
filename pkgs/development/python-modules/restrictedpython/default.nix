{ lib
, buildPythonPackage
, fetchPypi

# Test dependencies
, pytest, pytest-mock
}:

buildPythonPackage rec {
  pname = "RestrictedPython";
  version = "5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1g0sffn6ifkl1w8gq15rpaqm8c7l68bsnm77wcd3flyzzydmd050";
  };

  #propagatedBuildInputs = [ xmltodict requests ifaddr ];

  checkInputs = [
    pytest pytest-mock
  ];

  checkPhase = ''
    pytest
  '';

  meta = {
    homepage = https://github.com/zopefoundation/RestrictedPython;
    description = "A restricted execution environment for Python to run untrusted code";
    license = lib.licenses.zpl21;
    maintainers = with lib.maintainers; [ juaningan ];
  };
}
