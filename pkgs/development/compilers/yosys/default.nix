{ stdenv, fetchFromGitHub
, pkgconfig, tcl, readline, libffi, python3, bison, flex
}:

with builtins;

stdenv.mkDerivation rec {
  name = "yosys-${version}";
  version = "2018.05.03";

  srcs = [
    (fetchFromGitHub {
      owner  = "yosyshq";
      repo   = "yosys";
      rev    = "a572b495387743a58111e7264917a497faa17ebf";
      sha256 = "0q4xh4sy3n83c8il8lygzv0i6ca4qw36i2k6qz6giw0wd2pkibkb";
      name   = "yosys";
    })

    # NOTE: the version of abc used here is synchronized with
    # the one in the yosys Makefile of the version above;
    # keep them the same for quality purposes.
    (fetchFromGitHub {
      owner  = "berkeley-abc";
      repo   = "abc";
      rev    = "f23ea8e33f6d5cc54f58bec6d9200483e5d8c704";
      sha256 = "1xwmq3k5hfavdrs7zbqjxh35kr2pis4i6hhzrq7qzyzs0az0hls9";
      name   = "yosys-abc";
    })
  ];
  sourceRoot = "yosys";

  enableParallelBuilding = true;
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ tcl readline libffi python3 bison flex ];

  patchPhase = ''
    substituteInPlace ../yosys-abc/Makefile \
      --replace 'CC   := gcc' ""
    substituteInPlace ./Makefile \
      --replace 'CXX = clang' "" \
      --replace 'ABCMKARGS = CC="$(CXX)"' 'ABCMKARGS =' \
      --replace 'echo UNKNOWN' 'echo ${substring 0 10 (elemAt srcs 0).rev}'
  '';

  preBuild = ''
    chmod -R u+w ../yosys-abc
    ln -s ../yosys-abc abc
    make config-${if stdenv.cc.isClang or false then "clang" else "gcc"}
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
    platforms   = stdenv.lib.platforms.unix;
  };
}
