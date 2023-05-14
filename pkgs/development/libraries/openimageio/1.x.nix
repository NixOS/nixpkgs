{ lib, stdenv, fetchFromGitHub, boost, cmake, ilmbase, libjpeg, libpng, libtiff
, opencolorio_1, openexr, unzip
}:

stdenv.mkDerivation rec {
  pname = "openimageio";
  version = "1.8.17";

  src = fetchFromGitHub {
    owner = "OpenImageIO";
    repo = "oiio";
    rev = "Release-${version}";
    sha256 = "0zq34szprgkrrayg5sl3whrsx2l6lr8nw4hdrnwv2qhn70jbi2w2";
  };

  outputs = [ "bin" "out" "dev" "doc" ];

  nativeBuildInputs = [ cmake unzip ];
  buildInputs = [
    boost ilmbase libjpeg libpng
    libtiff opencolorio_1 openexr
  ];

  cmakeFlags = [
    "-DUSE_PYTHON=OFF"
  ];

  makeFlags = [
    "ILMBASE_HOME=${ilmbase.dev}"
    "OPENEXR_HOME=${openexr.dev}"
    "USE_PYTHON=0"
    "INSTALLDIR=${placeholder "out"}"
    "dist_dir="
  ];

  patches = [
    # Backported from https://github.com/OpenImageIO/oiio/pull/2539 for 1.8.17
    ./2539_backport.patch
  ];

  meta = with lib; {
    homepage = "http://www.openimageio.org";
    description = "A library and tools for reading and writing images";
    license = licenses.bsd3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.unix;
    knownVulnerabilities = [
      # all discovered in 2.x but there is no reason to
      # believe that these or similar vulnerabilties aren't
      # present in the totally unmaintained 1.x branch
      "CVE-2022-36354"
      "CVE-2022-38143"
      "CVE-2022-41639"
      "CVE-2022-41649"
      "CVE-2022-41684"
      "CVE-2022-41794"
      "CVE-2022-41837"
      "CVE-2022-41838"
      "CVE-2022-41977"
      "CVE-2022-41981"
      "CVE-2022-41988"
      "CVE-2022-41999"
      "CVE-2022-43592"
      "CVE-2022-43593"
      "CVE-2022-43594"
      "CVE-2022-43595"
      "CVE-2022-43596"
      "CVE-2022-43597"
      "CVE-2022-43598"
      "CVE-2022-43599"
      "CVE-2022-43600"
      "CVE-2022-43601"
      "CVE-2022-43602"
      "CVE-2022-43603"
      "CVE-2023-22845"
      "CVE-2023-24472"
      "CVE-2023-24473"
    ];
  };
}
