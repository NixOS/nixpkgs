{ lib
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "python-ptrace";
  version = "0.9.8";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1e3bc6223f626aaacde8a7979732691c11b13012e702fee9ae16c87f71633eaa";
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
