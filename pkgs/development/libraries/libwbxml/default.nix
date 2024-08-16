{ stdenv, fetchFromGitHub, lib, cmake, expat }:

stdenv.mkDerivation rec {
  pname = "libwbxml";
  version = "0.11.10";

  src = fetchFromGitHub {
    owner = "libwbxml";
    repo = "libwbxml";
    rev = "${pname}-${version}";
    sha256 = "sha256-yy8+CyNKXuttCmxRxH/XptIloDklto4f5Zg0vnwnneY=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ expat ];

  postPatch = ''
    sed -i 's/^SET.*$//' cmake/CMakeLists.txt
  '';

  meta = with lib; {
    homepage = "https://github.com/libwbxml/libwbxml";
    description = "WBXML Library (aka libwbxml) contains a library and its associated tools to Parse, Encode and Handle WBXML documents";
    maintainers = with maintainers; [ mh ];
    platforms = platforms.linux;
    license = licenses.lgpl21Plus;
  };
}
