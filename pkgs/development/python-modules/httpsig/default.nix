{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, pycryptodome
, requests
}:

buildPythonPackage rec {
  pname = "httpsig";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19ng7y7blp13z081z5a6dxng1p8xlih7g6frmsg3q5ri8lvpybc7";
  };

  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ pycryptodome requests ];

  # Jailbreak pycryptodome
  preBuild = ''
    substituteInPlace setup.py --replace "==3.4.7" ""
  '';

  meta = with lib; {
    description = "Sign HTTP requests with secure signatures";
    license = licenses.mit;
    maintainers = with maintainers; [ srhb ];
    homepage = https://github.com/ahknight/httpsig;
  };
}
