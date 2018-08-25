{ stdenv
, buildPythonPackage
, fetchPypi
, paramiko
, lxml
, libxml2
, libxslt
, nose
, rednose
}:

buildPythonPackage rec {
  pname = "ncclient";
  version = "0.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6616828f9c5d318906dae22378a78342bbfa5983f1775c1af8bfecc779434c38";
  };

  checkInputs = [ nose rednose ];

  propagatedBuildInputs = [
    paramiko lxml libxml2 libxslt
  ];

  checkPhase = ''
    nosetests test --rednose --verbosity=3 --with-coverage --cover-package ncclient
  '';

  #Unfortunately the test hangs at te end
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://ncclient.org/;
    description = "Python library for NETCONF clients";
    license = licenses.asl20;
    maintainers = with maintainers; [ xnaveira ];
  };
}
