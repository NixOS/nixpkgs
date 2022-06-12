# qmake2cmake

convert qmake projects to cmake

## usage

see examples in

* pkgs/development/python-modules/pyqt/6.nix
* pkgs/development/python-modules/pyqtwebengine/6.nix

## debugging

```nix
stdenv.mkDerivation {
  # debug cmake
  cmakeFlags = [ "--debug-output" ];
  # debug make
  makeFlags = [ "-d" ];
  QMAKE2CMAKE_DEBUG = "1";
  SIP_DEBUG = "1";
  PYQT_BUILDER_DEBUG = "1";
  # debug qmake2cmake: dump generated files to stdout (to the build log)
  QMAKE2CMAKE_DEBUG_DUMP_FILES = "1"; # dump *.pro and CMakeLists.txt files
  #PYQT_BUILDER_DEBUG_DUMP_MAKE_FILES = "1"; # dump Makefile files
  #SIP_DEBUG_DUMP_FILES = "1"; # dump *.cpp and *.h files
}
```
