{ stdenv
, fetchFromGitLab
, lib
, cmake
, libGL
, libglvnd
, makeWrapper
, pkg-config
, wayland
, libxcb
, libX11
}:

stdenv.mkDerivation rec {
  pname = "waffle";
  version = "1.6.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mesa";
    repo = "waffle";
    rev = "v${version}";
    sha256 = "0s8gislmhccfa04zsj1yqk97lscbbnmxirr2zm4q3p8ybmpfhpqr";
  };

  buildInputs = [
    libGL
    libglvnd
    libX11
    libxcb
    wayland
  ];

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
  ];

  cmakeFlags = [ "-Dplatforms=x11,wayland" ];

  postInstall = ''
    wrapProgram $out/bin/wflinfo \
      --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [ libGL libglvnd ]}
  '';

  meta = with lib; {
    description = "A cross-platform C library that allows one to defer selection of an OpenGL API and window system until runtime";
    homepage = "http://www.waffle-gl.org/";
    license = licenses.bsd2;
    platforms = platforms.mesaPlatforms;
    maintainers = with maintainers; [ Flakebi ];
  };
}
