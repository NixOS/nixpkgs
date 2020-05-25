{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, cffi
}:

buildPythonPackage rec {
  pname = "lmdb";
  version = "0.98";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0625bc28bf0893e6000a83be7234f915ca078c32f9e73d8ae48b3508db7af708";
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
