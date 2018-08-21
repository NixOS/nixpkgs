{ stdenv, fetchPypi, buildPythonPackage
, future, packbits, pillow, pyusb
, pytest, mock }:

buildPythonPackage rec {
  pname = "brother_ql";
  version = "0.8.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d77fdfdf0ab61ca45b9599fc3270fe98faa16d992e4ce098c66ac7f722787b87";
  };

  propagatedBuildInputs = [ future packbits pillow pyusb ];

  meta = with stdenv.lib; {
    description = "Python package for the raster language protocol of the Brother QL series label printers";
    long_description = ''Python package for the raster language protocol of the Brother QL series label printers
     (QL-500, QL-550, QL-570, QL-700, QL-710W, QL-720NW, QL-800, QL-820NWB, QL-1050 and more)'';
    homepage = https://github.com/pklaus/brother_ql;
    license = licenses.gpl3;
    maintainers = with maintainers; [ poelzi ];
  };
}
