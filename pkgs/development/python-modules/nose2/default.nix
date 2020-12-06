{ stdenv
, buildPythonPackage
, fetchPypi
, six
, pythonOlder
, coverage
}:

buildPythonPackage rec {
  pname = "nose2";
  version = "0.9.2";

  # Requires mock 2.0.0 if python < 3.6, but NixPkgs has mock 3.0.5.
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pmbb6nk31yhgh4zkcblzxsznml7f7pf5q1ihgrwvbxv4mwzfql7";
  };

  propagatedBuildInputs = [ six coverage ];

  # AttributeError: 'module' object has no attribute 'collector'
  doCheck = false;

  meta = with stdenv.lib; {
    description = "nose2 is the next generation of nicer testing for Python";
    homepage = "https://github.com/nose-devs/nose2";
    license = licenses.bsd0;
  };

}
