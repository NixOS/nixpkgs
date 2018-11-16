{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "python-ptrace";
  version = "0.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "019jlpya2d2b3vbg037hnj4z0f564r7ibygayda7bm7qbpw0sa4g";
  };

  # requires distorm, which is optionally
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python binding of ptrace library";
    homepage = https://github.com/vstinner/python-ptrace;
    license = licenses.gpl2;
    maintainers = with maintainers; [ mic92 ];
  };
}
