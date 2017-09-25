{ stdenv, buildPythonPackage, fetchPypi, maintainers, platforms, licenses, pkgs, self }:

# From the 1.10.0 documentation:
# "This version of Kivy requires at least Cython version 0.23, and has been
# tested through 0.25.2. Later versions may work, but as they have not been
# tested there is no guarantee."

assert stdenv.lib.versionAtLeast self.cython.version "0.23";

# Rather than depending on a specific older version of Cython, we accept the
# off-chance of breakage:
# assert stdenv.lib.versionOlder self.cython.version "0.25.3";

buildPythonPackage rec {
  pname = "Kivy";
  version = "1.10.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1394zh6kvf7k5d8vlzxcsfcailr3q59xwg9b1n7qaf25bvyq1h98";
  };

  # setup.py invokes git on build but we're fetching a tarball, so
  # can't retrieve git version. We remove the git-invocation from setup.py
  # This patch can presumably be removed on the next version of Kivy, because the problem
  # was addressed in https://github.com/kivy/kivy/issues/5365
  patches = [
    ./setup.py.patch
  ];

  buildInputs = with self; [
    pkgconfig
    cython

    kivygarden  # See https://github.com/kivy/kivy/issues/5367 suggestion I-2
    requests  # See https://github.com/kivy/kivy/issues/5367 suggestion I-3
    docutils # See https://github.com/kivy/kivy/issues/5367 question Q-5
    pygments # See https://github.com/kivy/kivy/issues/5367 question Q-6

    # nose  # needed for tests (which are currently disabled)

    # The setup below is, as much as I can figure out how to make it, an attempt
    # to create a "canonical full install" of Kivy on linux, as allued to in
    # https://github.com/kivy/kivy/issues/5367 question Q-7

    # Some sources to reconstruct such a thing are:
    # .travis.yml (which contains the actual build instructions for CI)
    # https://kivy.org/docs/installation/installation.html
    # https://kivy.org/docs/installation/installation-linux.html

    pkgs.mesa
    pkgs.mtdev

    pkgs.SDL2
    pkgs.SDL2_image
    pkgs.SDL2_ttf
    pkgs.SDL2_mixer

    # NOTE: The degree to which gstreamer actually works is unclear
    pkgs.gst_all_1.gstreamer
    pkgs.gst_all_1.gst-plugins-base
    pkgs.gst_all_1.gst-plugins-good
    pkgs.gst_all_1.gst-plugins-bad

    # Not done yet:
    # "Camera is also unclear in the cross-platform sense, though for a
    # canonical linux configuration the answer is probably opencv. SDL2 for
    # image provider qualifies as "canonical", though it is my impression that
    # ffpyplayer has wider and better format support."
    ];

  propagatedBuildInputs = with self; [
    pillow
    ] ;

  # We're not currently running tests, because there are 38 errors and 1 failure
  # This number may be reduced somewhat once https://github.com/kivy/kivy/issues/5373 is fixed

  # KIVY_NO_CONFIG is needed, because otherwise tests attempt to write to the non-existing $HOME
  # checkPhase = ''
  #   export KIVY_NO_CONFIG=1
  #   nosetests
  # '';

  doCheck = false;

  postPatch = ''
   substituteInPlace kivy/lib/mtdev.py \
     --replace "LoadLibrary('libmtdev.so.1')" "LoadLibrary('${pkgs.mtdev}/lib/libmtdev.so.1')"
  '';

  meta = {
    description = "A software library for rapid development of hardware-accelerated multitouch applications.";
    homepage    = "https://pypi.python.org/pypi/kivy";
    license     = licenses.mit;
    maintainers = with maintainers; [ vanschelven ];
    platforms   = platforms.unix;  # I can only test linux; in principle other platforms are supported
  };

}
