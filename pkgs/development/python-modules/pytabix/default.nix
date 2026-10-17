{
  lib,
  buildPythonPackage,
  isPy3k,
  fetchPypi,
  zlib,
}:

buildPythonPackage rec {
  pname = "pytabix";
  version = "0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-B3TxaH69QYEfsHoOUJUba+ctfMfiLtKxiXLq90gut9E=";
  };

  buildInputs = [ zlib ];

  doCheck = !isPy3k;
  preCheck = ''
    substituteInPlace test/test.py \
      --replace 'test_remote_file' 'dont_test_remote_file'
  '';
  pythonImportsCheck = [ "tabix" ];

  meta = {
    homepage = "https://github.com/slowkow/pytabix";
    description = "Python interface for tabix";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ris ];
  };
}
