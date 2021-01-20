{ lib, stdenv
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "python-ptrace";
  version = "0.9.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b998e3436cec975b6907552af6e7f3ff8779097e32d2b905696e5a9feb09e070";
  };

  # requires distorm, which is optionally
  doCheck = false;

  propagatedBuildInputs = [ six ];

  meta = with lib; {
    description = "Python binding of ptrace library";
    homepage = "https://github.com/vstinner/python-ptrace";
    license = licenses.gpl2;
    maintainers = with maintainers; [ mic92 ];
  };
}
