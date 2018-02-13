{ stdenv, fetchFromGitHub, fetchFromBitbucket
, pkgconfig, tcl, readline, libffi, python3, bison, flex
}:

stdenv.mkDerivation rec {
  name = "yosys-${version}";
  version = "2018.02.04";

  srcs = [
    (fetchFromGitHub {
      owner  = "yosyshq";
      repo   = "yosys";
      rev    = "0659d9eac7b546ee6f5acab46dbc83c91d556a34";
      sha256 = "1hy21gxcp3q3hlbh5sh46h2340r11fwalkb9if9sbpc9y3279njj";
      name   = "yosys";
    })
    (fetchFromBitbucket {
      owner  = "alanmi";
      repo   = "abc";
      rev    = "6e3c24b3308a";
      sha256 = "1i4wv0si4fb6dpv2yrpkp588mdlfrnx2s02q2fgra5apdm54c53w";
      name   = "yosys-abc";
    })
  ];
  sourceRoot = "yosys";

  enableParallelBuilding = true;
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ tcl readline libffi python3 bison flex ];
  preBuild = ''
    chmod -R u+w ../yosys-abc
    ln -s ../yosys-abc abc
    make config-gcc
    echo 'ABCREV := default' >> Makefile.conf
    makeFlags="PREFIX=$out $makeFlags"
  '';

  meta = {
    description = "Framework for RTL synthesis tools";
    longDescription = ''
      Yosys is a framework for RTL synthesis tools. It currently has
      extensive Verilog-2005 support and provides a basic set of
      synthesis algorithms for various application domains.
      Yosys can be adapted to perform any synthesis job by combining
      the existing passes (algorithms) using synthesis scripts and
      adding additional passes as needed by extending the yosys C++
      code base.
    '';
    homepage    = http://www.clifford.at/yosys/;
    license     = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ shell thoughtpolice ];
    platforms   = stdenv.lib.platforms.linux;
  };
}
