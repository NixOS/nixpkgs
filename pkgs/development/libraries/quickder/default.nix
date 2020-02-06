{ stdenv, fetchFromGitHub, python2Packages, hexio
, cmake, bash, arpa2cm, git, asn2quickder }:

stdenv.mkDerivation rec {
  pname = "quickder";
  version = "1.3.0";

  src = fetchFromGitHub {
    sha256 = "15lxv8vcjnsjxg7ywcac5p6mj5vf5pxq1219yap653ci4f1liqfr";
    rev = "version-${version}";
    owner = "vanrein";
    repo = "quick-der";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = with python2Packages; [
    arpa2cm
    asn1ate
    hexio
    pyparsing
    python
    six
    asn1ate
    asn2quickder
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
