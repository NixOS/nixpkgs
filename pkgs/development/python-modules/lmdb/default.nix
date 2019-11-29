{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, cffi
}:

buildPythonPackage rec {
  pname = "lmdb";
  version = "0.97";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0jw3n14x6qg5wps2w4qkqf4pyan949h1s2nbkrz2qh7xwnnp2g8p";
  };

  checkInputs = [ pytest cffi ];
  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "Universal Python binding for the LMDB 'Lightning' Database";
    homepage = "https://github.com/dw/py-lmdb";
    license = licenses.openldap;
    maintainers = with maintainers; [ copumpkin ivan ];
  };

}
