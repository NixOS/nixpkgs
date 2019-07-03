{ stdenv
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  version = "0.1.3";
  pname = "forbiddenfruit";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1188a07cc24a9bd2c529dad06490b80a6fc88cde968af4d7861da81686b2cc8c";
  };

  checkInputs = [ nose ];

  checkPhase = ''
    find ./build -name '*.so' -exec mv {} tests/unit \;
    nosetests
  '';

  meta = with stdenv.lib; {
    description = "Patch python built-in objects";
    homepage = https://pypi.python.org/pypi/forbiddenfruit;
    license = licenses.mit;
  };

}
