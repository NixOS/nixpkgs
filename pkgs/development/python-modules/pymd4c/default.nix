{ stdenv
, buildPythonPackage
, fetchPypi
, md4c
, pkg-config  # pkgs
, pkgconfig   # pythonPackages
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pymd4c";
  version = "0.4.6.0b1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07s3arn85ri92im6x3ipljdmrxmpik7irs06i6lm17j1x6j9841d";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ md4c pkgconfig ];

  # package does not contain any test
  doCheck = false;
  pythonImportsCheck = [ "md4c" ];

  meta = with stdenv.lib; {
    description = "Python bindings for MD4C";
    homepage = "https://github.com/dominickpastore/pymd4c";
    license = licenses.mit;
    maintainers = with maintainers; [ euandreh ];
  };
}
