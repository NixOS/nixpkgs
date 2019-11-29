{ stdenv, fetchFromGitHub, python2Packages, hexio
, which, cmake, bash, arpa2cm, git, asn2quickder, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "quickder";
  version = "1.2-6";

  src = fetchFromGitHub {
    sha256 = "00wifjydgmqw2i5vmr049visc3shjqccgzqynkmmhkjhs86ghzr6";
    rev = "version-${version}";
    owner = "vanrein";
    repo = "quick-der";
  };

  buildInputs = with python2Packages; [
    arpa2cm
    asn1ate
    bash
    cmake
    git
    hexio
    pyparsing
    python
    six
    which
    asn1ate
    asn2quickder
    pkgconfig
  ];

  postPatch = ''
    substituteInPlace ./CMakeLists.txt \
      --replace "get_version_from_git" "set (Quick-DER_VERSION 1.2) #"
    substituteInPlace ./CMakeLists.txt \
      --replace \$\{ARPA2CM_TOOLCHAIN_DIR} "$out/share/ARPA2CM/toolchain/"
    patchShebangs python/scripts/
  '';

  cmakeFlags = [
    "-DNO_TESTING=ON"
    "-DARPA2CM_TOOLCHAIN_DIR=$out/share/ARPA2CM/toolchain/"
    "-DCMAKE_EXPORT_NO_PACKAGE_REGISTRY=ON"
    "-DCMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY=ON"
    "-DPACKAGE_NO_PACKAGE_REGISTRY=ON"
  ];

  preConfigure = ''
    export PREFIX=$out
  '';

  meta = with stdenv.lib; {
    description = "Quick (and Easy) DER, a Library for parsing ASN.1";
    homepage = https://github.com/vanrein/quick-der;
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ leenaars ];
  };
}
