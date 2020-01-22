{ stdenv
, buildPythonPackage
, fetchPypi
, six
, pyyaml
, packaging
}:

buildPythonPackage rec {
  pname = "dparse";
  version = "0.4.1";

  buildInputs = [ six pyyaml packaging ];

  # Inpure integration tests
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "06bvn7m3xlfvw0l6ydm3b503ycsvj120sq7kkcayaa86j3xgv980";
  };

  meta = with stdenv.lib; {
    description = "A parser for Python dependency files";
    homepage = "https://github.com/pyupio/dparse";
    license = licenses.mit;
    maintainers = [ maintainers.mmahut ];
  };
}
