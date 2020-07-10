{ stdenv
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "python-ptrace";
  version = "0.9.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c46287ae611e3041bbd0572221cd1f121100dfc98d1d6c9ad6dd97e35f62501a";
  };

  # requires distorm, which is optionally
  doCheck = false;

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    description = "Python binding of ptrace library";
    homepage = "https://github.com/vstinner/python-ptrace";
    license = licenses.gpl2;
    maintainers = with maintainers; [ mic92 ];
  };
}
