{ lib, stdenv, fetchurl, cmake, pkg-config }:

stdenv.mkDerivation rec {
  pname = "uid_wrapper";
  version = "1.3.0";

  src = fetchurl {
    url = "mirror://samba/cwrap/uid_wrapper-${version}.tar.gz";
    sha256 = "sha256-9+fBveUzUwBRkxQUckRT4U4CrbthSCS2/ifLuYZUt2I=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  meta = with lib; {
    description = "A testing tool to fake privilege separation";
    homepage = "https://git.samba.org/?p=uid_wrapper.git;a=summary;";
    license = licenses.bsd3;
    platforms = platforms.all;
    changelog = "https://git.samba.org/?p=uid_wrapper.git;a=blob;f=CHANGELOG;hb=refs/tags/uid_wrapper-${version}";
  };
}
