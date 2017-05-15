{ stdenv
, buildPythonPackage
, fetchPypi
, python
, serpent
, dill
, msgpack
, six
, isPy27
}:
let 
  selectors34 = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "selectors34";
    version = "1.1";

    src = fetchPypi {
      inherit pname version;      
      sha256 = "0lmw1fp60qzcl1a0n0vfzfn7j7mrkbkiag6ipkmilij6j0xp9cw4";
    };

    propagatedBuildInputs = [ six ];

    doCheck = isPy27;

    meta = with stdenv.lib; {
      description = "a backport of the selectors module from Python 3.4";
      homepage = https://github.com/berkerpeksag/selectors34;
      license = licenses.psfl;
      maintainers = with maintainers; [ sdll ];
    };

  };
in buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "Pyro4";
  version = "4.59";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f1anx4gg5w719hvh104bixldzdylkw04m3zmganyfx8sbdxlfba";
  };

  propagatedBuildInputs = [
    selectors34
    serpent
  ];
  buildInputs = [    
    msgpack
    dill
  ];

  checkPhase = ''
    ${python.interpreter} setup.py test
  '';
  
  meta = with stdenv.lib; {
    description = "distributed object middleware for Python (RPC)";
    homepage = https://github.com/irmen/Pyro4;
    license = licenses.mit;
    maintainers = with maintainers; [ sdll ];
    };
}
