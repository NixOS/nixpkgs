{ stdenv, fetchFromGitHub, fetchFromBitbucket, pkgconfig, tcl, readline, libffi, python3, bison, flex }:

stdenv.mkDerivation rec {
  name = "yosys-${version}";
  version = "2016.05.21";

  srcs = [
    (fetchFromGitHub {
      owner = "cliffordwolf";
      repo = "yosys";
      rev = "8e9e793126a2772eed4b041bc60415943c71d5ee";
      sha256 = "1s0x7n7qh2qbfc0d7p4q10fvkr61jdqgyqzijr422rabh9zl4val";
      name = "yosys";
    })
    (fetchFromBitbucket {
      owner = "alanmi";
      repo = "abc";
      rev = "d9559ab";
      sha256 = "08far669khb65kfpqvjqmqln473j949ak07xibfdjdmiikcy533i";
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
