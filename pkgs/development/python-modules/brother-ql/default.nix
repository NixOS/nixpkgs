{ stdenv
, fetchPypi
, buildPythonPackage
, future
, packbits
, pillow
, pyusb
, pytest
, mock
, click
, attrs
, lib
}:

buildPythonPackage rec {
  pname = "brother-ql";
  version = "0.9.4";

  src = fetchPypi {
    pname = "brother_ql";
    inherit version;
    sha256 = "sha256-H1xXoDnwEsnCBDl/RwAB9267dINCHr3phdDLPGFOhmA=";
  };

  propagatedBuildInputs = [ future packbits pillow pyusb click attrs ];

  meta = with lib; {
    description = "Python package for the raster language protocol of the Brother QL series label printers";
    longDescription = ''
      Python package for the raster language protocol of the Brother QL series label printers
      (QL-500, QL-550, QL-570, QL-700, QL-710W, QL-720NW, QL-800, QL-820NWB, QL-1050 and more)
    '';
    homepage = "https://github.com/pklaus/brother_ql";
    license = licenses.gpl3;
    maintainers = with maintainers; [ grahamc ];
  };
}
