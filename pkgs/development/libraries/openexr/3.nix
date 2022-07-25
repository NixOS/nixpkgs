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
  version = "3.1.5";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "openexr";
    rev = "v${version}";
    sha256 = "sha256-mmzrMCYyAAa1z8fLZVbaTL1TZzdRaRTLgK+wzPuH4tg=";
  };

  outputs = [ "bin" "dev" "out" "doc" ];

  # tests are determined to use /var/tmp on unix
  postPatch = ''
    cat <(find . -name tmpDir.h) <(echo src/test/OpenEXRCoreTest/main.cpp) | while read -r f ; do
      substituteInPlace $f --replace '/var/tmp' "$TMPDIR"
    done
  '';

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
    imath
    zlib
  ];

  doCheck = true;

  meta = with lib; {
    description = "A high dynamic-range (HDR) image file format";
    homepage = "https://www.openexr.com";
    license = licenses.bsd3;
    maintainers = with maintainers; [ paperdigits ];
    platforms = platforms.all;
  };
}
