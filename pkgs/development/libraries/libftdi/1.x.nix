{ lib
, stdenv
, fetchgit
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
  version = "1.5";

  src = fetchgit {
    url = "git://developer.intra2net.com/libftdi";
    rev = "v${version}";
    sha256 = "0vipg3y0kbbzjhxky6hfyxy42mpqhvwn1r010zr5givcfp8ghq26";
  };

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
    "-DPYTHON_EXECUTABLE=${python3.pythonForBuild.interpreter}"
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

  postFixup = optionalString cppSupport ''
    # This gets misassigned to the C++ version's path for some reason
    for fileToFix in $out/{bin/libftdi1-config,lib/pkgconfig/libftdi1.pc}; do
      substituteInPlace $fileToFix \
        --replace "$out/include/libftdipp1" "$out/include/libftdi1"
    done
  '';

  meta = with lib; {
    description = "A library to talk to FTDI chips using libusb";
    homepage = "https://www.intra2net.com/en/developer/libftdi/";
    license = with licenses; [ lgpl2Only gpl2Only ];
    platforms = platforms.all;
    maintainers = with maintainers; [ bjornfor ];
  };
}
