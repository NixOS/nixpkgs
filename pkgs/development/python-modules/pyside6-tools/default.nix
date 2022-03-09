{ buildPythonPackage, wrapPython, python, fetchurl, lib, stdenv, cmake, qt6,
  shiboken6, pyside6 }:

stdenv.mkDerivation rec {
  pname = "pyside6-tools";

  inherit (pyside6) version src;

  patches = [
    # Upstream has a crazy build system only geared towards producing binary
    # wheels distributed via pypi.  For this, they copy the `uic` and `rcc`
    # binaries to the wheel.
    #./remove_hacky_binary_copying.patch
  ];

  postPatch = ''
    cd $sourceRoot/${pname}
  '';

  nativeBuildInputs = [ cmake wrapPython ];
  propagatedBuildInputs = [ shiboken6 pyside6 ];
  buildInputs = [ python qt6.qtbase ];

  cmakeFlags = [
    "-DBUILD_TESTS=OFF"
  ];

  dontWrapQtApps = true;

  # The upstream build system consists of a `setup.py` whichs builds three
  # different python libraries and calls cmake as a subprocess.  We call cmake
  # directly because that's easier to get working.  However, the `setup.py`
  # build also creates a few wrapper scripts, which we replicate here:
  postInstall = ''
    rm $out/bin/pyside_tool.py

    for tool in uic rcc; do
      makeWrapper "$(command -v $tool)" $out/bin/pyside6-$tool --add-flags "-g python"
    done
  '';

  postFixup = ''
    wrapPythonPrograms
  '';

  meta = with lib; {
    description = "pyside6 development tools";
    license = licenses.gpl2;
    homepage = "https://wiki.qt.io/Qt_for_Python";
    maintainers = with maintainers; [ gebner ];
  };
}
