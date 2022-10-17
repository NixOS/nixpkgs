{ stdenv
, fetchFromGitHub
, cmake
, flex
, bison
, libxml2
, python
, libusb1
, avahi
, libaio
, runtimeShell
, lib
}:

stdenv.mkDerivation rec {
  pname = "libiio";
  version = "0.23";

  outputs = [ "out" "lib" "dev" "python" ];

  src = fetchFromGitHub {
    owner = "analogdevicesinc";
    repo = "libiio";
    rev = "v${version}";
    sha256 = "0awny9zb43dcnxa5jpxay2zxswydblnbn4x6vi5mlw1r48pzhjf8";
  };

  # Revert after https://github.com/NixOS/nixpkgs/issues/125008 is
  # fixed properly
  patches = [ ./cmake-fix-libxml2-find-package.patch ];

  nativeBuildInputs = [
    cmake
    flex
    bison
  ];

  buildInputs = [
    python
    libxml2
    libusb1
    avahi
    libaio
  ] ++ lib.optional python.isPy3k python.pkgs.setuptools;

  cmakeFlags = [
    "-DUDEV_RULES_INSTALL_DIR=${placeholder "out"}/lib/udev/rules.d"
    "-DPYTHON_BINDINGS=on"
  ];

  postPatch = ''
    # Hardcode path to the shared library into the bindings.
    sed "s#@libiio@#$lib/lib/libiio${stdenv.hostPlatform.extensions.sharedLibrary}#g" ${./hardcode-library-path.patch} | patch -p1

    substituteInPlace libiio.rules.cmakein \
      --replace /bin/sh ${runtimeShell}
  '';

  postInstall = ''
    # Move Python bindings into a separate output.
    moveToOutput ${python.sitePackages} "$python"
  '';

  meta = with lib; {
    description = "API for interfacing with the Linux Industrial I/O Subsystem";
    homepage = "https://github.com/analogdevicesinc/libiio";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
