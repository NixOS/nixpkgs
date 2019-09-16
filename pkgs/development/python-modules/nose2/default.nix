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
  version = "0.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16drs4bc2wvgwwi1pf6pmk6c00pl16vs1v7djc4a8kwpsxpibphf";
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
