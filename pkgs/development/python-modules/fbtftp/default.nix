{ lib, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
  pname = "fbtftp";
  version = "0.4";

  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qbfwk2qbbv8z0mf3hyykkp32lisv7g64w26ki7rf8nifj2lgnn6";
  };

  meta = {
    description = "Facebook's implementation of a dynamic TFTP server framework";
    homepage = "https://github.com/facebook/fbtftp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ guibou French-isotope ];
  };
}
