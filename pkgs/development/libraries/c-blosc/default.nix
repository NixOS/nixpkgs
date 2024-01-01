{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "c-blosc";
  version = "1.21.5";

  src = fetchFromGitHub {
    owner = "Blosc";
    repo = "c-blosc";
    rev = "v${version}";
    sha256 = "sha256-bz922lWiap3vMy8qS9dmXa8zUg5NJlg0bx3+/xz7QAk=";
  };

  # https://github.com/NixOS/nixpkgs/issues/144170
  postPatch = ''
    sed -i -E \
      -e '/^libdir[=]/clibdir=@CMAKE_INSTALL_FULL_LIBDIR@' \
      -e '/^includedir[=]/cincludedir=@CMAKE_INSTALL_FULL_INCLUDEDIR@' \
      blosc.pc.in
  '';

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "A blocking, shuffling and loss-less compression library";
    homepage = "https://www.blosc.org";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ ris ];
  };
}
