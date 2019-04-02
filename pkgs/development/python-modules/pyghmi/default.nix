{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, cryptography
, oslotest
, pbr
}:

buildPythonPackage rec{
  pname = "pyghmi";
  version = "1.2.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2b474e04f526035d2fc0e2f0b22246316ea34af1dca8269201bbd202812d7a99";
  };

  buildInputs = [ pbr oslotest cryptography ];

  #checkInputs = [ nose ];

#  checkPhase = ''
#    # https://github.com/pytoolz/toolz/issues/357
#    rm toolz/tests/test_serialization.py
#    nosetests toolz/tests
#  '';

  meta = with lib; {
    homepage = https://github.com/openstack/pyghmi;
    description = "A Pure python IPMI library";
    license = licenses.apache;
    maintainers = with maintainers; [ cptMikky ];
  };
}

