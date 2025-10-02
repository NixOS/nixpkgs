{
  lib,
  stdenv,
  substitute,
  fetchpatch,
  fetchurl,
  fetchFromGitHub,
  cmake,
  pkg-config,
  # See https://files.ettus.com/manual_archive/v3.15.0.0/html/page_build_guide.html for dependencies explanations
  boost,
  ncurses,
  enableCApi ? true,
  enablePythonApi ? true,
  python3,
  enableExamples ? false,
  enableUtils ? true,
  libusb1,
  # Disable dpdk for now due to compilation issues.
  enableDpdk ? false,
  dpdk,
  # Devices
  enableOctoClock ? true,
  enableMpmd ? true,
  enableB100 ? true,
  enableB200 ? true,
  enableUsrp1 ? true,
  enableUsrp2 ? true,
  enableX300 ? true,
  enableX400 ? true,
  enableN300 ? true,
  enableN320 ? true,
  enableE300 ? true,
  enableE320 ? true,
}:

let
  inherit (lib) optionals cmakeBool;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "uhd";
  # NOTE: Use the following command to update the package, and the uhdImageSrc attribute:
  #
  #     nix-shell maintainers/scripts/update.nix --argstr package uhd --argstr commit true
  #
  version = "4.9.0.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "EttusResearch";
    repo = "uhd";
    rev = "v${finalAttrs.version}";
    # The updateScript relies on the `src` using `hash`, and not `sha256. To
    # update the correct hash for the `src` vs the `uhdImagesSrc`
    hash = "sha256-XA/ADJ0HjD6DxqFTVMwFa7tRgM56mHAEL+a0paWxKyM=";
  };
  # Firmware images are downloaded (pre-built) from the respective release on Github
  uhdImagesSrc = fetchurl {
    url = "https://github.com/EttusResearch/uhd/releases/download/v${finalAttrs.version}/uhd-images_${finalAttrs.version}.tar.xz";
    # Please don't convert this to a hash, in base64, see comment near src's
    # hash.
    sha256 = "194gsmvn7gmwj7b1lw9sq0d0y0babbd0q1229qbb3qjc6f6m0p0y";
  };
  # This are the minimum required Python dependencies, this attribute might
  # be useful if you want to build a development environment with a python
  # interpreter able to import the uhd module.
  pythonPath =
    optionals (enablePythonApi || enableUtils) [
      python3.pkgs.numpy
      python3.pkgs.setuptools
    ]
    ++ optionals (enableUtils) [
      python3.pkgs.requests
      python3.pkgs.six

      /*
        These deps are needed for the usrp_hwd.py utility, however even if they
        would have been added here, the utility wouldn't have worked because it
        depends on an old python library mprpc that is not supported for Python >
        3.8. See also report upstream:
        https://github.com/EttusResearch/uhd/issues/744

        python3.pkgs.gevent
        python3.pkgs.pyudev
        python3.pkgs.pyroute2
      */
    ];
  passthru = {
    runtimePython = python3.withPackages (ps: finalAttrs.pythonPath);
    updateScript = [
      ./update.sh
      # Pass it this file name as argument
      (builtins.unsafeGetAttrPos "pname" finalAttrs.finalPackage).file
    ];
  };

  cmakeFlags = [
    "-DENABLE_LIBUHD=ON"
    "-DENABLE_USB=ON"
    # Regardless of doCheck, we want to build the tests to help us gain
    # confident that the package is OK.
    "-DENABLE_TESTS=ON"
    (cmakeBool "ENABLE_EXAMPLES" enableExamples)
    (cmakeBool "ENABLE_UTILS" enableUtils)
    (cmakeBool "ENABLE_C_API" enableCApi)
    (cmakeBool "ENABLE_PYTHON_API" enablePythonApi)
    /*
      Otherwise python tests fail. Using a dedicated pythonEnv for either or both
      nativeBuildInputs and buildInputs makes upstream's cmake scripts fail to
      install the Python API as reported on our end at [1] (we don't want
      upstream to think we are in a virtual environment because we use
      python3.withPackages...).

      Putting simply the python dependencies in the nativeBuildInputs and
      buildInputs as they are now from some reason makes the `python` in the
      checkPhase fail to find the python dependencies, as reported at [2]. Even
      using nativeCheckInputs with the python dependencies, or using a
      `python3.withPackages` wrapper in nativeCheckInputs, doesn't help, as the
      `python` found in $PATH first is the one from nativeBuildInputs.

      [1]: https://github.com/NixOS/nixpkgs/pull/307435
      [2]: https://discourse.nixos.org/t/missing-python-package-in-checkphase/9168/

      Hence we use upstream's provided cmake flag to control which python
      interpreter they will use to run the the python tests.
    */
    "-DRUNTIME_PYTHON_EXECUTABLE=${lib.getExe finalAttrs.passthru.runtimePython}"
    (cmakeBool "ENABLE_DPDK" enableDpdk)
    # Devices
    (cmakeBool "ENABLE_OCTOCLOCK" enableOctoClock)
    (cmakeBool "ENABLE_MPMD" enableMpmd)
    (cmakeBool "ENABLE_B100" enableB100)
    (cmakeBool "ENABLE_B200" enableB200)
    (cmakeBool "ENABLE_USRP1" enableUsrp1)
    (cmakeBool "ENABLE_USRP2" enableUsrp2)
    (cmakeBool "ENABLE_X300" enableX300)
    (cmakeBool "ENABLE_X400" enableX400)
    (cmakeBool "ENABLE_N300" enableN300)
    (cmakeBool "ENABLE_N320" enableN320)
    (cmakeBool "ENABLE_E300" enableE300)
    (cmakeBool "ENABLE_E320" enableE320)
    # TODO: Check if this still needed
    # ABI differences GCC 7.1
    # /nix/store/wd6r25miqbk9ia53pp669gn4wrg9n9cj-gcc-7.3.0/include/c++/7.3.0/bits/vector.tcc:394:7: note: parameter passing for argument of type 'std::vector<uhd::range_t>::iterator {aka __gnu_cxx::__normal_iterator<uhd::range_t*, std::vector<uhd::range_t> >}' changed in GCC 7.1
  ]
  ++ optionals stdenv.hostPlatform.isAarch32 [
    "-DCMAKE_CXX_FLAGS=-Wno-psabi"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    # Present both here and in buildInputs for cross compilation.
    python3
    python3.pkgs.mako
    # We add this unconditionally, but actually run wrapPythonPrograms only if
    # python utilities are enabled
    python3.pkgs.wrapPython
  ];
  buildInputs =
    finalAttrs.pythonPath
    ++ [
      boost
      libusb1
    ]
    ++ optionals (enableExamples) [
      ncurses
      ncurses.dev
    ]
    ++ optionals (enableDpdk) [
      dpdk
    ];

  patches = [
    ./fix-pkg-config.patch
  ];

  # many tests fails on darwin, according to ofborg
  doCheck = !stdenv.hostPlatform.isDarwin;

  doInstallCheck = true;

  # Build only the host software
  preConfigure = "cd host";

  postPhases = [
    "installFirmware"
    "removeInstalledTests"
  ]
  ++ optionals (enableUtils && stdenv.hostPlatform.isLinux) [
    "moveUdevRules"
  ];

  # UHD expects images in `$CMAKE_INSTALL_PREFIX/share/uhd/images`
  installFirmware = ''
    mkdir -p "$out/share/uhd/images"
    tar --strip-components=1 -xvf "${finalAttrs.uhdImagesSrc}" -C "$out/share/uhd/images"
  '';

  # -DENABLE_TESTS=ON installs the tests, we don't need them in the output
  removeInstalledTests = ''
    rm -r $out/lib/uhd/tests
  '';

  # Moves the udev rules to the standard location, needed only if utils are
  # enabled
  moveUdevRules = ''
    mkdir -p $out/lib/udev/rules.d
    mv $out/lib/uhd/utils/uhd-usrp.rules $out/lib/udev/rules.d/
  '';

  # Wrap the python utilities with our pythonPath definition
  postFixup = lib.optionalString (enablePythonApi && enableUtils) ''
    wrapPythonPrograms
  '';
  disallowedReferences = optionals (!enablePythonApi && !enableUtils) [
    python3
  ];

  meta = with lib; {
    description = "USRP Hardware Driver (for Software Defined Radio)";
    longDescription = ''
      The USRP Hardware Driver (UHD) software is the hardware driver for all
      USRP (Universal Software Radio Peripheral) devices.

      USRP devices are designed and sold by Ettus Research, LLC and its parent
      company, National Instruments.
    '';
    homepage = "https://uhd.ettus.com/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [
      bjornfor
      fpletz
      tomberek
      doronbehar
    ];
  };
})
