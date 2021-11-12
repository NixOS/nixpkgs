{ lib, stdenv
, buildPythonPackage, fetchFromGitHub, fetchpatch
, pkg-config, cython, docutils
, kivy-garden
, mesa, mtdev, SDL2, SDL2_image, SDL2_ttf, SDL2_mixer
, ApplicationServices, AVFoundation, libcxx
, withGstreamer ? true
, gst_all_1
, pillow, requests, pygments
}:

buildPythonPackage rec {
  pname = "Kivy";
  version = "2.0.0";

  # use github since pypi line endings are CRLF and patches do not apply
  src = fetchFromGitHub {
    owner = "kivy";
    repo = "kivy";
    rev = version;
    sha256 = "sha256-/7GSVQUkYSBEnLVBizMnZAZZxvXVN4r4lskyOgLEcew=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/kivy/kivy/commit/1c0656c4472817677cf3b08be504de9ca6b1713f.patch";
      sha256 = "sha256-phAjMaC3LQuvufwiD0qXzie5B+kezCf8FpKeQMhy/ms=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    cython
    docutils
  ];

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_ttf
    SDL2_mixer
  ] ++ lib.optionals stdenv.isLinux [
    mesa
    mtdev
  ] ++ lib.optionals stdenv.isDarwin [
    ApplicationServices
    AVFoundation
    libcxx
  ] ++ lib.optionals withGstreamer (with gst_all_1; [
    # NOTE: The degree to which gstreamer actually works is unclear
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
  ]);

  propagatedBuildInputs = [
    kivy-garden
    pillow
    pygments
    requests
  ];

  KIVY_NO_CONFIG = 1;
  KIVY_NO_ARGS = 1;
  KIVY_NO_FILELOG = 1;
  # prefer pkg-config over hardcoded framework paths
  USE_OSX_FRAMEWORKS = 0;
  # work around python distutils compiling C++ with $CC (see issue #26709)
  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-I${lib.getDev libcxx}/include/c++/v1";

  postPatch = lib.optionalString stdenv.isLinux ''
    substituteInPlace kivy/lib/mtdev.py \
      --replace "LoadLibrary('libmtdev.so.1')" "LoadLibrary('${mtdev}/lib/libmtdev.so.1')"
  '';

  /*
    We cannot run tests as Kivy tries to import itself before being fully
    installed.
  */
  doCheck = false;
  pythonImportsCheck = [ "kivy" ];

  meta = with lib; {
    description = "Library for rapid development of hardware-accelerated multitouch applications.";
    homepage = "https://pypi.python.org/pypi/kivy";
    license = licenses.mit;
    maintainers = with maintainers; [ risson ];
  };
}
