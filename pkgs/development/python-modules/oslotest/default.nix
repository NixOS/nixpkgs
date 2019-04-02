{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, fixtures
, mox3
, subunit
}:

buildPythonPackage rec{
  pname = "oslotest";
  version = "3.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c29ff0199be630653ce4fe83748dd8a58659fa4524e877e3213320645178cb97";
  };

  buildInputs = [ fixtures mox3 subunit ];

  #checkInputs = [ nose ];

#  checkPhase = ''
#    # https://github.com/pytoolz/toolz/issues/357
#    rm toolz/tests/test_serialization.py
#    nosetests toolz/tests
#  '';

  meta = with lib; {
    homepage = https://github.com/openstack/oslotest/;
    description = "OpenStack Testing Framework and Utilities`";
    license = licenses.apache;
    maintainers = with maintainers; [ cptMikky ];
  };
}

