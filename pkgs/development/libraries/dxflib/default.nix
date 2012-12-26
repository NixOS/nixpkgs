{stdenv, fetchurl}: 

stdenv.mkDerivation rec {
  version = "2.5.0.0-1";
  name = "dxflib-${version}";
  src = fetchurl {
    url = "http://www.qcad.org/archives/dxflib/${name}.src.tar.gz";
    sha256 = "20ad9991eec6b0f7a3cc7c500c044481a32110cdc01b65efa7b20d5ff9caefa9";
  };

  meta = {
    maintainers = with stdenv.lib.maintainers; [raskin];
    platforms = stdenv.lib.platforms.linux;
    description = ''DXF file format library'';
  };
}

