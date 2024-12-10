{
  stdenv,
  fetchFromGitHub,
  lib,
  cmake,
  expat,
}:

stdenv.mkDerivation rec {
  pname = "libwbxml";
  version = "0.11.8";

  src = fetchFromGitHub {
    owner = "libwbxml";
    repo = "libwbxml";
    rev = "${pname}-${version}";
    sha256 = "sha256-WCVKfIk6R2rVaz1SbJL9eLqNC0f4VzL74Sw2IKdDE9I=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ expat ];

  postPatch = ''
    sed -i 's/^SET.*$//' cmake/CMakeLists.txt
  '';

  meta = with lib; {
    homepage = "https://github.com/libwbxml/libwbxml";
    description = "The WBXML Library (aka libwbxml) contains a library and its associated tools to Parse, Encode and Handle WBXML documents";
    maintainers = with maintainers; [ mh ];
    platforms = platforms.linux;
    license = licenses.lgpl21Plus;
  };
}
