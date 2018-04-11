{ stdenv, fetchFromGitHub, fetchFromBitbucket
, pkgconfig, tcl, readline, libffi, python3, bison, flex
}:

with builtins;

stdenv.mkDerivation rec {
  name = "yosys-${version}";
  version = "2018.02.14";

  srcs = [
    (fetchFromGitHub {
      owner  = "yosyshq";
      repo   = "yosys";
      rev    = "c1abd3b02cab235334342f3520e2535eb74c5792";
      sha256 = "0pzrplv4p0qzy115rg19lxv4w274iby337zfd7hhlinnpx3gzqvw";
      name   = "yosys";
    })

    # NOTE: the version of abc used here is synchronized with
    # the one in the yosys Makefile of the version above;
    # keep them the same for quality purposes.
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
