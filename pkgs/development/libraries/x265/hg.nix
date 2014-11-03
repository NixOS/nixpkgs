{ stdenv, cmake, fetchhg, yasm
, highBitDepth ? false
, debuggingSupport ? false
, enableCli ? true
, testSupport ? false
}:

stdenv.mkDerivation rec {
  name = "x265-hg";

  src = fetchhg {
    url = "https://bitbucket.org/multicoreware/x265/src";
    rev = "eebb372eec893efc50e66806fcc19b1c1bd89683";
    sha256 = "03dpbjqcmbmyid45560byabybfzy2bvic0gqa6k6hxci6rvmynpi";
  };

  cmakeFlags = with stdenv.lib;
    ''
      ${if debuggingSupport
        then "-DCHECKED_BUILD=ON"
        else "-DCHECKED_BUILD=OFF"
      }
      -DSTATIC_LINK_CRT=OFF
      ${if (stdenv.system == "x86_64-linux" && highBitDepth)
        then "-DHIGH_BIT_DEPTH=ON"
        else "-DHIGH_BIT_DEPTH=OFF"
      }
      -DWARNINGS_AS_ERRORS=OFF
      -DENABLE_PPA=OFF
      -DENABLE_SHARED=ON
      ${if enableCli
        then "-DENABLE_CLI=ON"
        else "-DENABLE_CLI=OFF"
      }
      ${if testSupport
        then "-DENABLE_TESTS=ON"
        else "-DENABLE_TESTS=OFF"
      }
    '';

  preConfigure = "cd source";

  buildInputs = [ cmake yasm ];

  meta = with stdenv.lib; {
    homepage = "http://x265.org";
    description = "Library for encoding h.265/HEVC video streams";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ codyopel ];
  };
}