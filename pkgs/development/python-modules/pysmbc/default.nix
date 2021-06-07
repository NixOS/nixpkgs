{ lib
, buildPythonPackage
, fetchPypi
, samba
, pkg-config
}:

buildPythonPackage rec {
  pname = "pysmbc";
  version = "1.0.23";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1y0n1n6jkzf4mr5lqfc73l2m0qp56gvxwfjnx2vj8c0hh5i1gnq8";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ samba ];

  # Tests would require a local SMB server
  doCheck = false;
  pythonImportsCheck = [ "smbc" ];

  meta = with lib; {
    description = "libsmbclient binding for Python";
    homepage = "https://github.com/hamano/pysmbc";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
