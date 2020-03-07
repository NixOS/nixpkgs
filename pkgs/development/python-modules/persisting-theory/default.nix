{ stdenv, buildPythonPackage, fetchPypi
, nose
}:

buildPythonPackage rec {
  pname = "persisting-theory";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02hcg7js23yjyw6gwxqzvyv2b1wfjrypk98cfxfgf7s8iz67vzq0";
  };

  checkInputs = [ nose ];

  checkPhase = "nosetests";

  meta = with stdenv.lib; {
    homepage = https://code.eliotberriot.com/eliotberriot/persisting-theory;
    description = "Automate data discovering and access inside a list of packages";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmai ];
  };
}
