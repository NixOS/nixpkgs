{ stdenv
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "python-ptrace";
  version = "0.9.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9885e9003e4a99c90b3bca1be9306181c9b40a33fc6e17b81027709be5e5cb87";
  };

  # requires distorm, which is optionally
  doCheck = false;

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    description = "Python binding of ptrace library";
    homepage = https://github.com/vstinner/python-ptrace;
    license = licenses.gpl2;
    maintainers = with maintainers; [ mic92 ];
  };
}
