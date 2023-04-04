{ buildPythonPackage, fetchPypi, lib, dfdatetime, libregf-python, libcreg-python
, dtfabric, pyyaml }:
buildPythonPackage rec {
  pname = "dfwinreg";
  name = pname;
  version = "20221218";

  meta = with lib; {
    description =
      "dfWinReg, or Digital Forensics Windows Registry, provides read-only access to Windows Registry objects";
    platforms = platforms.all;
    homepage = "https://github.com/log2timeline/dfwinreg";
    downloadPage = "https://github.com/log2timeline/dfwinreg/releases";
    maintainers = with maintainers; [ jayrovacsek ];
    license = licenses.asl20;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-qY49wRXGuK86lE12pJz17AxbKg+oAD2sXXy8eLS3LS0=";
  };

  doCheck = false;

  propagatedBuildInputs =
    [ dfdatetime libregf-python libcreg-python pyyaml dtfabric ];
}
