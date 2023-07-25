{ lib, fetchurl, stdenv, slang, popt, python }:

let
  pythonIncludePath = "${lib.getDev python}/include/python";
in
stdenv.mkDerivation rec {
  pname = "newt";
  version = "0.52.23";

  src = fetchurl {
    url = "https://releases.pagure.org/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-yqNykHsU7Oz+KY8NUSpi9B0zspBhAkSliu0Hu8WtoSo=";
  };

  postPatch = ''
    sed -i -e s,/usr/bin/install,install, -e s,-I/usr/include/slang,, Makefile.in po/Makefile

    substituteInPlace configure \
      --replace "/usr/include/python" "${pythonIncludePath}"
    substituteInPlace configure.ac \
      --replace "/usr/include/python" "${pythonIncludePath}"

    substituteInPlace Makefile.in \
      --replace "ar rv" "${stdenv.cc.targetPrefix}ar rv"
  '';

  strictDeps = true;
  nativeBuildInputs = [ python ];
  buildInputs = [ slang popt ];

  NIX_LDFLAGS = "-lncurses";

  preConfigure = ''
    # If CPP is set explicitly, configure and make will not agree about which
    # programs to use at different stages.
    unset CPP
  '';

  configureFlags = lib.optionals stdenv.isDarwin [
    "--disable-nls"
  ];

  makeFlags = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];

  postFixup = lib.optionalString stdenv.isDarwin ''
    install_name_tool -id $out/lib/libnewt.so.${version} $out/lib/libnewt.so.${version}
    install_name_tool -change libnewt.so.${version} $out/lib/libnewt.so.${version} $out/bin/whiptail
  '';

  meta = with lib; {
    homepage = "https://pagure.io/newt";
    description = "Library for color text mode, widget based user interfaces";

    license = licenses.lgpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.viric ];
  };
}
