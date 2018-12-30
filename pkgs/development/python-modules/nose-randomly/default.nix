{ lib
, buildPythonPackage
, fetchPypi
, nose
, numpy
}:

buildPythonPackage rec {
  pname = "nose-randomly";
  version = "1.2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "361f4c2fbb090ec2bc8e5e4151e21409a09ac13f364e3448247cc01f326d89b3";
  };

  checkInputs = [ numpy ];
  propagatedBuildInputs = [
    nose
  ];

  checkPhase = ''
    nosetests
  '';

  meta = with lib; {
    description = "Nose plugin to randomly order tests and control random.seed";
    homepage = https://github.com/adamchainz/nose-randomly;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
