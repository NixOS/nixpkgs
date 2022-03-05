{ stdenv, fetchFromGitHub, lib, cmake, expat }:

stdenv.mkDerivation rec {
  pname = "libwbxml";
  version = "0.11.7";

  src = fetchFromGitHub {
    owner = "libwbxml";
    repo = "libwbxml";
    rev = "${pname}-${version}";
    sha256 = "sha256:1b81rbkd28d9059vh8n5gql73crp8h7av67kkmr6lhicl08fv2xx";
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
