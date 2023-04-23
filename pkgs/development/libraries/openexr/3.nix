{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, zlib
, cmake
, imath
}:

stdenv.mkDerivation rec {
  pname = "openexr";
  version = "3.1.7";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "openexr";
    rev = "v${version}";
    sha256 = "sha256-Kl+aOA797aZvrvW4ZQNHdSU7YFPieZEzX3aYeaoH6eU=";
  };

  outputs = [ "bin" "dev" "out" "doc" ];

  # tests are determined to use /var/tmp on unix
  postPatch = ''
    cat <(find . -name tmpDir.h) <(echo src/test/OpenEXRCoreTest/main.cpp) | while read -r f ; do
      substituteInPlace $f --replace '/var/tmp' "$TMPDIR"
    done
  '';

  cmakeFlags = lib.optional stdenv.hostPlatform.isStatic "-DCMAKE_SKIP_RPATH=ON";

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ imath zlib ];

  # Without 'sse' enforcement tests fail on i686 as due to excessive precision as:
  #   error reading back channel B pixel 21,-76 got -nan expected -nan
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isi686 "-msse2 -mfpmath=sse";

  doCheck = true;

  meta = with lib; {
    description = "A high dynamic-range (HDR) image file format";
    homepage = "https://www.openexr.com";
    license = licenses.bsd3;
    maintainers = with maintainers; [ paperdigits ];
    platforms = platforms.all;
  };
}
