{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "daff";
  version = "1.4.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-R/A5Htp+K1AR98ysAGuReKzLRlvLlKLJ8oQlf/9dJoY=";
  };

  # there are no tests
  doCheck = false;

  pythonImportsCheck = [ "daff" ];

  meta = with lib; {
    description = "Library for comparing tables, producing a summary of their differences, and using such a summary as a patch file";
    homepage = "https://github.com/paulfitz/daff";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ turion ];
  };
}
