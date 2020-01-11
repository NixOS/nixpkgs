{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  version = "3.12.2";
  pname = "dxflib";
  src = fetchurl {
    url = "http://www.qcad.org/archives/dxflib/${pname}-${version}.src.tar.gz";
    sha256 = "20ad9991eec6b0f7a3cc7c500c044481a32110cdc01b65efa7b20d5ff9caefa9";
  };

  meta = {
    maintainers = with stdenv.lib.maintainers; [raskin];
    platforms = stdenv.lib.platforms.linux;
    description = ''DXF file format library'';
  };
}

