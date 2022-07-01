{ stdenv
, fetchFromGitHub
, cmake
, flex
, bison
, libxml2
, python
, libusb1
, runtimeShell
, lib
}:

stdenv.mkDerivation rec {
  pname = "libiio";
  version = "0.21";

  outputs = [ "out" "lib" "dev" "python" ];

  src = fetchFromGitHub {
    owner = "analogdevicesinc";
    repo = "libiio";
    rev = "v${version}";
    sha256 = "0psw67mzysdb8fkh8xpcwicm7z94k8plkcc8ymxyvl6inshq0mc7";
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
