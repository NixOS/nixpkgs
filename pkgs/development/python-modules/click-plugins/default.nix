{
  lib,
  buildPythonPackage,
  fetchPypi,
  click,
  pytest,
}:

buildPythonPackage rec {
  pname = "click-plugins";
  version = "1.1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RquZl0Sp2DEVnDQRuwx5NG2UpETfmjo3QuntY2RfJks=";
  };

  propagatedBuildInputs = [ click ];

  nativeCheckInputs = [ pytest ];

  meta = with lib; {
    description = "Extension module for click to enable registering CLI commands";
    homepage = "https://github.com/click-contrib/click-plugins";
    license = licenses.bsd3;
    maintainers = with maintainers; [ knedlsepp ];
  };
}
