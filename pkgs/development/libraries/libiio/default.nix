{ stdenv
, fetchFromGitHub
, cmake
, flex
, bison
, libxml2
<<<<<<< HEAD
, pythonSupport ? stdenv.hostPlatform.hasSharedLibraries, python
=======
, python
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, libusb1
, avahiSupport ? true, avahi
, libaio
, runtimeShell
, lib
, pkg-config
, CFNetwork
, CoreServices
}:

stdenv.mkDerivation rec {
  pname = "libiio";
  version = "0.24";

<<<<<<< HEAD
  outputs = [ "out" "lib" "dev" ]
    ++ lib.optional pythonSupport "python";
=======
  outputs = [ "out" "lib" "dev" "python" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "analogdevicesinc";
    repo = "libiio";
    rev = "v${version}";
    sha256 = "sha256-c5HsxCdp1cv5BGTQ/8dc8J893zk9ntbfAudLpqoQ1ow=";
  };

  # Revert after https://github.com/NixOS/nixpkgs/issues/125008 is
  # fixed properly
  patches = [ ./cmake-fix-libxml2-find-package.patch ];

  nativeBuildInputs = [
    cmake
    flex
    bison
    pkg-config
<<<<<<< HEAD
  ] ++ lib.optionals pythonSupport ([
    python
  ] ++ lib.optional python.isPy3k python.pkgs.setuptools);
=======
    python
  ] ++ lib.optional python.isPy3k python.pkgs.setuptools;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [
    libxml2
    libusb1
  ] ++ lib.optional avahiSupport avahi
    ++ lib.optional stdenv.isLinux libaio
    ++ lib.optionals stdenv.isDarwin [ CFNetwork CoreServices ];

  cmakeFlags = [
    "-DUDEV_RULES_INSTALL_DIR=${placeholder "out"}/lib/udev/rules.d"
<<<<<<< HEAD
=======
    "-DPython_EXECUTABLE=${python.pythonForBuild.interpreter}"
    "-DPYTHON_BINDINGS=on"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    # osx framework is disabled,
    # the linux-like directory structure is used for proper output splitting
    "-DOSX_PACKAGE=off"
    "-DOSX_FRAMEWORK=off"
<<<<<<< HEAD
  ] ++ lib.optionals pythonSupport [
    "-DPython_EXECUTABLE=${python.pythonForBuild.interpreter}"
    "-DPYTHON_BINDINGS=on"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ] ++ lib.optionals (!avahiSupport) [
    "-DHAVE_DNS_SD=OFF"
  ];

  postPatch = ''
<<<<<<< HEAD
    substituteInPlace libiio.rules.cmakein \
      --replace /bin/sh ${runtimeShell}
  '' + lib.optionalString pythonSupport ''
    # Hardcode path to the shared library into the bindings.
    sed "s#@libiio@#$lib/lib/libiio${stdenv.hostPlatform.extensions.sharedLibrary}#g" ${./hardcode-library-path.patch} | patch -p1
  '';

  postInstall = lib.optionalString pythonSupport ''
=======
    # Hardcode path to the shared library into the bindings.
    sed "s#@libiio@#$lib/lib/libiio${stdenv.hostPlatform.extensions.sharedLibrary}#g" ${./hardcode-library-path.patch} | patch -p1

    substituteInPlace libiio.rules.cmakein \
      --replace /bin/sh ${runtimeShell}
  '';

  postInstall = ''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    # Move Python bindings into a separate output.
    moveToOutput ${python.sitePackages} "$python"
  '';

  meta = with lib; {
    description = "API for interfacing with the Linux Industrial I/O Subsystem";
    homepage = "https://github.com/analogdevicesinc/libiio";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
