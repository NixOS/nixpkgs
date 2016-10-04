{ stdenv, fetchFromGitHub, fetchFromBitbucket, pkgconfig, tcl, readline, libffi, python3, bison, flex }:

stdenv.mkDerivation rec {
  name = "yosys-${version}";
  version = "2016.08.18";

  srcs = [
    (fetchFromGitHub {
      owner = "cliffordwolf";
      repo = "yosys";
      rev = "9b8e06bee177f53c34a9dd6dd907a822f21659be";
      sha256 = "0x5c1bcayahn7pbgycxkxr6lkv9m0jpwfdlmyp2m9yzm2lpyw7dg";
      name = "yosys";
    })
    (fetchFromBitbucket {
      owner = "alanmi";
      repo = "abc";
      rev = "a2e5bc66a68a";
      sha256 = "09yvhj53af91nc54gmy7cbp7yljfcyj68a87494r5xvdfnsj11gy";
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
