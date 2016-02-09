{ stdenv, fetchFromGitHub, fetchFromBitbucket, pkgconfig, tcl, readline, libffi, python3, bison, flex }:

stdenv.mkDerivation rec {
  name = "yosys-${version}";
  version = "2015.12.29";

  srcs = [
    (fetchFromGitHub {
      owner = "cliffordwolf";
      repo = "yosys";
      rev = "1d62f8710f04fec405ef79b9e9a4a031afcf7d42";
      sha256 = "0q1dk9in3gmrihb58pjckncx56lj7y4b6y34jgb68f0fh91fdvfx";
      name = "yosys";
    })
    (fetchFromBitbucket {
      owner = "alanmi";
      repo = "abc";
      rev = "c3698e053a7a";
      sha256 = "05p0fvbr7xvb6w3d7j2r6gynr3ljb6r5q6jvn2zs3ysn2b003qwd";
      name = "abc";
    })
  ];
  sourceRoot = "yosys";

  buildInputs = [ pkgconfig tcl readline libffi python3 bison flex ];
  preBuild = ''
    chmod -R u+w ../abc
    ln -s ../abc abc
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
  };
}
