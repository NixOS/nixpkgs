{ buildPythonPackage, fetchPypi, lib, appdirs, sqlalchemy, setuptools-scm }:

buildPythonPackage rec {
  pname = "cachew";
  version = "0.11.0";

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ appdirs sqlalchemy ];

  doCheck = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4qjgvffInKRpKST9xbwwC2+m8h3ups0ZePyJLUU+KhA=";
  };

  meta = with lib; {
    description =
      "Transparent and persistent cache/serialization powered by type hints";
    homepage = "https://github.com/karlicoss/cachew";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ qbit ];
  };
}
