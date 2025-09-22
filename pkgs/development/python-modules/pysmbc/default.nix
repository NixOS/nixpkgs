{
  lib,
  buildPythonPackage,
  fetchPypi,
  samba,
  pkg-config,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pysmbc";
  version = "1.0.25.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IvFxXfglif2cxCU/6rOQtO8Lq/FPZFE82NB7N4mWMiY=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ samba ];

  # Tests would require a local SMB server
  doCheck = false;

  pythonImportsCheck = [ "smbc" ];

  meta = with lib; {
    description = "Libsmbclient binding for Python";
    homepage = "https://github.com/hamano/pysmbc";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
