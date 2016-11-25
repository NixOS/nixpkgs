{ stdenv, fetchFromGitHub, fetchFromBitbucket, pkgconfig, tcl, readline, libffi, python3, bison, flex }:

stdenv.mkDerivation rec {
  name = "yosys-${version}";
  version = "2016.11.25";

  srcs = [
    (fetchFromGitHub {
      owner = "cliffordwolf";
      repo = "yosys";
      rev = "5c2c78e2dd12a860f830dafd73fbed8edf1a3823";
      sha256 = "1cvfkg0hllp7k2g52mxczd8d0ad7inlpkg27rrbyani2kg0066bk";
      name = "yosys";
    })
    (fetchFromBitbucket {
      owner = "alanmi";
      repo = "abc";
      rev = "238674cd44f2";
      sha256 = "18xk7lqai05am11zymixilgam4jvz5f2jwy9cgillz035man2yzw";
      name = "yosys-abc";
    })
  ];
  sourceRoot = "yosys";

  buildInputs = [ pkgconfig tcl readline libffi python3 bison flex ];
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
    homepage = http://www.clifford.at/yosys/;
    license = stdenv.lib.licenses.isc;
    maintainers = [ stdenv.lib.maintainers.shell ];
    platforms = stdenv.lib.platforms.linux;
  };
}
