{ lib
, stdenv
, fetchgit
, fetchpatch
, cmake
, pkg-config
, libusb1
, libconfuse
, cppSupport ? true
, boost
, pythonSupport ? true
, python3
, swig
, docSupport ? true
, doxygen
, graphviz
}:

let
  inherit (lib) optionals optionalString;
  onOff = a: if a then "ON" else "OFF";
in
stdenv.mkDerivation rec {
  pname = "libftdi";
  version = "1.5-unstable-2023-12-21";

  src = fetchgit {
    url = "git://developer.intra2net.com/libftdi";
    rev = "de9f01ece34d2fe6e842e0250a38f4b16eda2429";
    hash = "sha256-U37M5P7itTF1262oW+txbKxcw2lhYHAwy1ML51SDVMs=";
  };

  patches = [
    (fetchpatch {
      # http://developer.intra2net.com/mailarchive/html/libftdi/2024/msg00024.html
      # https://bugzilla.redhat.com/show_bug.cgi?id=2319133
      name = "swig-4.3.0-fix.patch";
      url = "https://src.fedoraproject.org/rpms/libftdi/raw/9051ea9ea767eced58b69d855a5d700a5d4602cc/f/libftdi-1.5-swig-4.3.patch";
      hash = "sha256-X5tqiPewnyAyvLzR6s0VbNpZKLd0idtPGU4ro36CZHI=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [ cmake pkg-config ]
    ++ optionals docSupport [ doxygen graphviz ]
    ++ optionals pythonSupport [ swig ];

  buildInputs = [ libconfuse ]
    ++ optionals cppSupport [ boost ];

  cmakeFlags = [
    "-DFTDIPP=${onOff cppSupport}"
    "-DBUILD_TESTS=${onOff cppSupport}"
    "-DLINK_PYTHON_LIBRARY=${onOff pythonSupport}"
    "-DPYTHON_BINDINGS=${onOff pythonSupport}"
    "-DDOCUMENTATION=${onOff docSupport}"
  ] ++ lib.optionals pythonSupport [
    "-DPYTHON_EXECUTABLE=${python3.pythonOnBuildForHost.interpreter}"
    "-DPYTHON_LIBRARY=${python3}/lib/libpython${python3.pythonVersion}${stdenv.hostPlatform.extensions.sharedLibrary}"
  ];

  propagatedBuildInputs = [ libusb1 ];

  postInstall = ''
    mkdir -p "$out/etc/udev/rules.d/"
    cp ../packages/99-libftdi.rules "$out/etc/udev/rules.d/"
  '' + optionalString docSupport ''
    cp -r doc/man "$out/share/"
    cp -r doc/html "$out/share/doc/libftdi1/"
  '';

  meta = with lib; {
    description = "Library to talk to FTDI chips using libusb";
    homepage = "https://www.intra2net.com/en/developer/libftdi/";
    license = with licenses; [ lgpl2Only gpl2Only ];
    platforms = platforms.all;
    maintainers = with maintainers; [ bjornfor ];
  };
}
