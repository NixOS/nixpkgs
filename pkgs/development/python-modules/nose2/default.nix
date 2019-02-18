{ stdenv
, buildPythonPackage
, fetchPypi
, six
, pythonOlder
, mock
, coverage
}:

buildPythonPackage rec {
  pname = "nose2";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9052f2b46807b63d9bdf68e0768da1f8386368889b50043fd5d0889c470258f3";
  };

  propagatedBuildInputs = [ six coverage ]
    ++ stdenv.lib.optionals (pythonOlder "3.4") [ mock ];

  # AttributeError: 'module' object has no attribute 'collector'
  doCheck = false;

  meta = with stdenv.lib; {
    description = "nose2 is the next generation of nicer testing for Python";
    homepage = https://github.com/nose-devs/nose2;
    license = licenses.bsd0;
  };

}
