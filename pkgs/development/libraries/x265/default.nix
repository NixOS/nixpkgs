{ stdenv, cmake, fetchurl, yasm
, highBitDepth ? false
, debuggingSupport ? false
, enableCli ? true
, testSupport ? false
}:

stdenv.mkDerivation rec {
  version = "1.3";
  name = "x265-${version}";

  src = fetchurl {
    url = "mirror://gentoo/distfiles/${name}.tar.bz2";
    sha256 = "3807090a99bc351894d58eb037db4f1487b2dba3489eb2c38ab43dd6b7c9b09d";
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