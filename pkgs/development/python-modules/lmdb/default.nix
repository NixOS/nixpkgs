{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, cffi
}:

buildPythonPackage rec {
  pname = "lmdb";
  version = "0.99";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f9eb844aaaacc8a4bc175e1c1f8a8fb538c330e378fd9eb40e8708d4dca7dc89";
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
