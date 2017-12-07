{ stdenv, fetchFromGitHub, fetchFromBitbucket
, pkgconfig, tcl, readline, libffi, python3, bison, flex
}:

stdenv.mkDerivation rec {
  name = "yosys-${version}";
  version = "2017.12.06";

  srcs = [
    (fetchFromGitHub {
      owner  = "cliffordwolf";
      repo   = "yosys";
      rev    = "8f2638ae2f12a48dcad14f24b0211c16ac724762";
      sha256 = "0synbskclgn97hp28myvl0hp8pqp66awp37z4cv7zl154ipysfl1";
      name   = "yosys";
    })
    (fetchFromBitbucket {
      owner  = "alanmi";
      repo   = "abc";
      rev    = "31fc97b0aeed";
      sha256 = "0ljmclr4hfh3iiyfw7ji0fm8j983la8021xfpnfd20dyc807hh65";
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
