{ buildPythonPackage
, dfdatetime
, dtfabric
, fetchPypi
, lib
, libcreg-python
, libregf-python
, pyyaml
}:

buildPythonPackage rec {
  pname = "dfwinreg";

  version = "20221218";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-qY49wRXGuK86lE12pJz17AxbKg+oAD2sXXy8eLS3LS0=";
  };

  propagatedBuildInputs = [
    dfdatetime
    dtfabric
    libcreg-python
    libregf-python
    pyyaml
  ];

  doCheck = false;

  meta = with lib; {
    description = "dfWinReg, or Digital Forensics Windows Registry, provides read-only access to Windows Registry objects.";
    downloadPage = "https://github.com/log2timeline/dfwinreg/releases";
    homepage = "https://github.com/log2timeline/dfwinreg";
    license = licenses.asl20;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };
}
