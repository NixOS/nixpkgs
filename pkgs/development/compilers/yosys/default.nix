{ stdenv, fetchFromGitHub, fetchFromBitbucket, pkgconfig, tcl, readline, libffi, python3, bison, flex }:

stdenv.mkDerivation rec {
  name = "yosys-${version}";
  version = "2017.09.01";

  srcs = [
    (fetchFromGitHub {
      owner = "cliffordwolf";
      repo = "yosys";
      rev = "18609f3df82a3403c41d552908183f7e49ff5678";
      sha256 = "0qdjxqg3l098g8pda5a4cif4bd78rx7vilv3z62r56ppj55mgw96";
      name = "yosys";
    })
    (fetchFromBitbucket {
      owner = "alanmi";
      repo = "abc";
      rev = "ff5be0604997";
      sha256 = "08gdvxm44dvhgjw6lf2jx0xyk6h4ai37h6b88dysvaa69sx7rh8n";
      name = "yosys-abc";
    })
  ];
  sourceRoot = "yosys";

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
    homepage = http://www.clifford.at/yosys/;
    license = stdenv.lib.licenses.isc;
    maintainers = [ stdenv.lib.maintainers.shell ];
    platforms = stdenv.lib.platforms.linux;
  };
}
