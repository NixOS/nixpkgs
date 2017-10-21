{ stdenv, fetchFromGitHub, fetchFromBitbucket
, pkgconfig, tcl, readline, libffi, python3, bison, flex
}:

stdenv.mkDerivation rec {
  name = "yosys-${version}";
  version = "2017.10.16";

  srcs = [
    (fetchFromGitHub {
      owner = "cliffordwolf";
      repo = "yosys";
      rev = "716dbc92745aa8b41d85a60d50263433d5a79393";
      sha256 = "0va77my4iddsw6psgjfhfgs0z0z1hpj0l8ipchcl8crpxipxcr77";
      name = "yosys";
    })
    (fetchFromBitbucket {
      owner = "alanmi";
      repo = "abc";
      rev = "6283c5d99b06";
      sha256 = "1mv8r1la4d4r9bk32sl4nq3flyxi8jf2ccaak64j5rz9hirrlpla";
      name = "yosys-abc";
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
