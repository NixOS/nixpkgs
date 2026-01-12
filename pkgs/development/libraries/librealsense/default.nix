{
  stdenv,
  config,
  coreutils,
  lib,
  fetchFromGitHub,
  runtimeShell,
  cmake,
  gnugrep,
  gawk,
  libusb1,
  nlohmann_json,
  ninja,
  makeWrapper,
  pkg-config,
  gcc,
  libgbm,
  gtk3,
  glfw,
  libGLU,
  curl,
  v4l-utils,
  cudaSupport ? config.cudaSupport,
  cudaPackages ? { },
  enablePython ? false,
  pythonPackages ? null,
  enableGUI ? false,
}:

assert cudaSupport -> (cudaPackages ? cudatoolkit && cudaPackages.cudatoolkit != null);
assert enablePython -> pythonPackages != null;

let
  stdenv' = if cudaSupport then cudaPackages.backendStdenv else stdenv;
in

stdenv'.mkDerivation rec {
  pname = "librealsense";
  version = "2.56.3";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "IntelRealSense";
    repo = "librealsense";
    rev = "v${version}";
    sha256 = "sha256-Stx337mGcpMCg9DlZmvX4LPQmCSzLRFcUQPxaD/Y0Ds=";
  };

  buildInputs = [
    libusb1
    gcc.cc.lib
    nlohmann_json
  ]
  ++ lib.optionals cudaSupport [ cudaPackages.cuda_cudart ]
  ++ lib.optionals enablePython (
    with pythonPackages;
    [
      python
      pybind11
    ]
  )
  ++ lib.optionals enableGUI [
    libgbm
    gtk3
    glfw
    libGLU
    curl
  ];

  patches = [
    ./py_pybind11_no_external_download.patch
    ./install-presets.patch
  ];

  postPatch = ''
    # use nixpkgs nlohmann_json instead of fetching it
    substituteInPlace third-party/CMakeLists.txt \
      --replace-fail \
        'include(CMake/external_json.cmake)' \
        'find_package(nlohmann_json 3.11.3 REQUIRED)'
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    makeWrapper
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
  ];

  cmakeFlags = [
    "-DBUILD_EXAMPLES=ON"
    "-DBUILD_GRAPHICAL_EXAMPLES=${lib.boolToString enableGUI}"
    "-DBUILD_GLSL_EXTENSIONS=${lib.boolToString enableGUI}"
    "-DCHECK_FOR_UPDATES=OFF" # activated by BUILD_GRAPHICAL_EXAMPLES, will make it download and compile libcurl
  ]
  ++ lib.optionals enablePython [
    "-DBUILD_PYTHON_BINDINGS:bool=true"
    "-DXXNIX_PYTHON_SITEPACKAGES=${placeholder "out"}/${pythonPackages.python.sitePackages}"
  ]
  ++ lib.optional cudaSupport "-DBUILD_WITH_CUDA:bool=true";

  # ensure python package contains its __init__.py. for some reason the install
  # script does not do this, and it's questionable if intel knows it should be
  # done
  # ( https://github.com/IntelRealSense/meta-intel-realsense/issues/20 )
  postInstall = ''
    libexec=$out/libexec

    mkdir -p $out/lib/udev/rules.d
    mkdir -p $libexec

    # To be consumed via services.udev.packages.
    install -m644 ../config/99-realsense-d4xx-mipi-dfu.rules $out/lib/udev/rules.d
    install -m644 ../config/99-realsense-libusb.rules $out/lib/udev/rules.d

    # Copy all binaries used by rules.
    install -m755 ../config/usb-R200-in $libexec
    install -m755 ../config/usb-R200-in_udev $libexec
    install -m755 ../scripts/rs-enum.sh $libexec
    install -m755 ../scripts/rs_ipu6_d457_bind.sh $libexec

    # Patch all shebangs.
    patchShebangs $libexec

    substituteInPlace $libexec/usb-R200-in_udev \
      --replace-fail '/usr/local/bin/usb-R200-in' $libexec/usb-R200-i

    substituteInPlace $libexec/usb-R200-in \
      --replace-fail 'lockdir="/dswork.lock"' 'lockdir="/run/lock/dswork.lock"'

    wrapProgram $libexec/rs-enum.sh \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          gawk
          gnugrep
          v4l-utils
        ]
      }

    wrapProgram $libexec/rs_ipu6_d457_bind.sh \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          gnugrep
          v4l-utils
        ]
      }

    # Replace plugdev group with uaccess tag for modern systemd behavior
    substituteInPlace $out/lib/udev/rules.d/99-realsense-libusb.rules \
      --replace-fail "/bin/sh" "${runtimeShell}" \
      --replace-fail "chmod" "${coreutils}/bin/chmod" \
      --replace-fail "uname" "${coreutils}/bin/uname" \
      --replace-fail "sleep" "${coreutils}/bin/sleep" \
      --replace-fail "cut" "${coreutils}/bin/cut" \
      --replace-fail 'GROUP:="plugdev"' 'TAG+="uaccess"' \
      --replace-fail '/usr/local/bin/usb-R200-in_udev' $libexec/usb-R200-in_udev

    substituteInPlace $out/lib/udev/rules.d/99-realsense-d4xx-mipi-dfu.rules \
      --replace-fail '/bin/bash' '${runtimeShell}' \
      --replace-fail 'rs_ipu6_d457_bind.sh' $libexec/rs_ipu6_d457_bind.sh \
      --replace-fail 'rs-enum.sh' $libexec/rs-enum.sh

    substituteInPlace $out/lib/cmake/realsense2/realsense2Targets.cmake \
      --replace-fail "\''${_IMPORT_PREFIX}/include" "$dev/include"
  ''
  + lib.optionalString enablePython ''
    cp ../wrappers/python/pyrealsense2/__init__.py $out/${pythonPackages.python.sitePackages}/pyrealsense2
  '';

  meta = {
    description = "Cross-platform library for Intel® RealSense™ depth cameras (D400 series and the SR300)";
    homepage = "https://github.com/IntelRealSense/librealsense";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      brian-dawn
      pbsds
    ];
    platforms = lib.platforms.unix;
  };
}
