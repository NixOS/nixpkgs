{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "utf8cpp";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "nemtrif";
    repo = "utfcpp";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "1s2pda75488z7c3w3a6qv31bj239248696yk5j2a1drbg2x1dpfh";
  };

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=None"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DINSTALL_GTEST=OFF"
  ];

  nativeBuildInputs = [ cmake ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/nemtrif/utfcpp";
    description = "UTF-8 with C++ in a Portable Way";
    license = licenses.free;
    maintainers = with maintainers; [ jobojeha ];
    platforms = platforms.linux;
  };
}
