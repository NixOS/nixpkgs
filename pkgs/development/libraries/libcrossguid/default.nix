{ lib, stdenv, fetchFromGitHub, libuuid, cmake }:

stdenv.mkDerivation rec {
  name = "lib" + pname + "-" + version;
  pname = "crossguid";
  version = "2019-05-29";

  src = fetchFromGitHub {
    owner = "graeme-hill";
    repo = pname;
    rev = "ca1bf4b810e2d188d04cb6286f957008ee1b7681";
    sha256 = "sha256-37tKPDo4lukl/aaDWWSQYfsBNEnDjE7t6OnEZjBhcvQ=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libuuid ];

  meta = with lib; {
    description = "Lightweight cross platform C++ GUID/UUID library";
    license = licenses.mit;
    maintainers = with maintainers; [ edwtjo ];
    homepage = "https://github.com/graeme-hill/crossguid";
    platforms = with platforms; linux;
  };

}
