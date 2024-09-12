{
  stdenv,
  lib,
  autoPatchelfHook,
  aravis,
  bash,
  boost,
  cmake,
  coreutils,
  cfitsio,
  fetchFromGitHub,
  gtest,
  libusb1,
  libusb-compat-0_1,
  zlib,
  libnova,
  curl,
  libjpeg,
  gsl,
  indilib,
  libcamera,
  libdc1394,
  libdrm,
  libexif,
  libftdi1,
  libgphoto2,
  libgpiod_1,
  libpng,
  libraw,
  ninja,
  nut,
  glib,
  systemd,
  urjtag,
  gpsd,
  ffmpeg-headless,
  limesuite,
  pkg-config,
  zeromq,
}:

let
  fxload = libusb1.override { withExamples = true; };
  src-3rdparty = fetchFromGitHub {
    owner = "indilib";
    repo = "indi-3rdparty";
    rev = "v${indilib.version}";
    hash = "sha256-RhtdhMvseQUUFcKDuR1N5qc/86IxmQ/7owpjT+qweqc=";
  };

  buildIndi3rdParty =
    args@{
      pname,
      nativeBuildInputs ? [ ],
      propagatedBuildInputs ? [ ],
      cmakeFlags ? [ ],
      postInstall ? "",
      doCheck ? true,
      version ? indilib.version,
      src ? src-3rdparty,
      meta ? { },
      ...
    }:
    stdenv.mkDerivation (
      args
      // {
        pname = "indi-3rdparty-${pname}";
        inherit src version;

        sourceRoot = "source/${pname}";

        cmakeFlags =
          [
            "-DCMAKE_INSTALL_LIBDIR=lib"
            "-DUDEVRULES_INSTALL_DIR=lib/udev/rules.d"
            "-DRULES_INSTALL_DIR=lib/udev/rules.d"
            "-DINDI_DATA_DIR=share/indi/"
          ]
          ++ lib.optional doCheck [
            "-DINDI_BUILD_UNITTESTS=ON"
            "-DINDI_BUILD_INTEGTESTS=ON"
          ]
          ++ cmakeFlags;

        nativeBuildInputs = [
          cmake
          ninja
          pkg-config
        ] ++ nativeBuildInputs;

        checkInputs = [ gtest ];

        postInstall = ''
          mkdir -p $out/lib/udev/rules.d/
          shopt -s nullglob
          for i in $propagatedBuildInputs; do
            echo "Adding rules for package $i"
            for j in $i/{etc,lib}/udev/rules.d/*; do
              echo "Linking $j to $out/lib/udev/rules.d/$(basename $j)"
              ln -s $j $out/lib/udev/rules.d/$(basename $j)
            done
          done
          ${postInstall}
        '';

        meta =
          with lib;
          {
            homepage = "https://www.indilib.org/";
            description = "Third party drivers for the INDI astronomical software suite";
            changelog = "https://github.com/indilib/indi-3rdparty/releases/tag/v${version}";
            license = licenses.lgpl2Plus;
            maintainers = with maintainers; [
              hjones2199
              sheepforce
              returntoreality
            ];
            platforms = platforms.linux;
          }
          // meta;
      }
    );

  libahp-gt = buildIndi3rdParty {
    pname = "libahp-gt";
    meta = with lib; {
      license = licenses.unfreeRedistributable;
      platforms = with platforms; x86_64 ++ aarch64 ++ i686 ++ arm;
    };
  };

  # broken: needs libdfu
  libahp-xc = buildIndi3rdParty {
    pname = "libahp-xc";
    buildInputs = [
      libusb-compat-0_1
      urjtag
      libftdi1
    ];
    meta = with lib; {
      license = licenses.unfreeRedistributable;
      broken = true;
      platforms = [ ];
    };
  };

  libaltaircam = buildIndi3rdParty {
    pname = "libaltaircam";
    meta = with lib; {
      license = licenses.unfreeRedistributable;
      platforms = with platforms; x86_64 ++ aarch64 ++ arm;
    };
  };

  libapogee = buildIndi3rdParty {
    pname = "libapogee";
    buildInputs = [
      curl
      indilib
      libusb1
    ];
    nativeBuildInputs = [ autoPatchelfHook ];
    cmakeFlags = [ "-DCONF_DIR=etc/" ];
    meta = with lib; {
      license = licenses.mpl20;
      platforms = platforms.linux;
    };
  };

  libasi = buildIndi3rdParty {
    pname = "libasi";
    buildInputs = [
      libusb1
      stdenv.cc.cc.lib
    ];
    nativeBuildInputs = [ autoPatchelfHook ];
    meta = with lib; {
      license = licenses.unfreeRedistributable;
      platforms = with platforms; x86_64 ++ aarch64 ++ i686 ++ arm;
    };
  };

  libastroasis = buildIndi3rdParty {
    pname = "libastroasis";
    buildInputs = [ stdenv.cc.cc.lib ];
    nativeBuildInputs = [ autoPatchelfHook ];
    meta = with lib; {
      license = licenses.unfreeRedistributable;
      platforms = with platforms; x86_64 ++ aarch64 ++ arm;
    };
  };

  libatik = buildIndi3rdParty {
    pname = "libatik";
    buildInputs = [
      stdenv.cc.cc.lib
      libusb1
      systemd
      libdc1394
    ];
    nativeBuildInputs = [ autoPatchelfHook ];
    meta = with lib; {
      license = licenses.unfreeRedistributable;
      platforms = with platforms; x86_64 ++ aarch64 ++ i686 ++ arm;
    };
  };

  libbressercam = buildIndi3rdParty {
    pname = "libbressercam";
    nativeBuildInputs = [ autoPatchelfHook ];
    meta = with lib; {
      license = licenses.unfreeRedistributable;
      platforms = with platforms; x86_64 ++ aarch64 ++ arm;
    };
  };

  libfishcamp = buildIndi3rdParty {
    pname = "libfishcamp";

    postPatch = ''
      substituteInPlace CMakeLists.txt --replace-fail "/lib/firmware" "lib/firmware"
    '';

    buildInputs = [
      indilib
      libusb1
    ];

    meta = with lib; {
      license = licenses.bsd2;
      platforms = platforms.linux;
    };
  };

  libfli = buildIndi3rdParty {
    pname = "libfli";
    buildInputs = [
      indilib
      libusb1
    ];
    meta = with lib; {
      license = licenses.bsd2;
      platforms = platforms.linux;
    };
  };

  libinovasdk = buildIndi3rdParty {
    pname = "libinovasdk";
    buildInputs = [
      stdenv.cc.cc.lib
      libusb1
    ];
    nativeBuildInputs = [ autoPatchelfHook ];
    meta = with lib; {
      license = lib.licenses.unfreeRedistributable;
      platforms = with platforms; x86_64 ++ aarch64 ++ arm ++ i686;
    };
  };

  libmallincam = buildIndi3rdParty {
    pname = "libmallincam";
    nativeBuildInputs = [ autoPatchelfHook ];
    meta = with lib; {
      license = lib.licenses.unfreeRedistributable;
      platforms = with platforms; x86_64 ++ aarch64 ++ arm;
    };
  };

  libmeadecam = buildIndi3rdParty {
    pname = "libmeadecam";
    buildInputs = [ libusb1 ];
    meta = with lib; {
      license = lib.licenses.lgpl21Only;
      platforms = platforms.linux;
    };
  };

  libmicam = buildIndi3rdParty {
    pname = "libmicam";
    buildInputs = [ libusb1 ];
    nativeBuildInputs = [ autoPatchelfHook ];
    meta = with lib; {
      license = lib.licenses.unfreeRedistributable;
      platforms = with platforms; x86_64 ++ aarch64 ++ arm ++ i686;
    };
  };

  libnncam = buildIndi3rdParty {
    pname = "libnncam";
    nativeBuildInputs = [ autoPatchelfHook ];
    meta = with lib; {
      license = lib.licenses.unfreeRedistributable;
      platforms = with platforms; x86_64 ++ aarch64 ++ arm;
    };
  };

  libogmacam = buildIndi3rdParty {
    pname = "libogmacam";
    nativeBuildInputs = [ autoPatchelfHook ];
    meta = with lib; {
      license = lib.licenses.unfreeRedistributable;
      platforms = with platforms; x86_64 ++ aarch64 ++ arm;
    };
  };

  libomegonprocam = buildIndi3rdParty {
    pname = "libomegonprocam";
    nativeBuildInputs = [ autoPatchelfHook ];
    meta = with lib; {
      license = lib.licenses.unfreeRedistributable;
      platforms = with platforms; x86_64 ++ aarch64 ++ arm;
    };
  };

  # broken: needs pigpio library
  libpigpiod = buildIndi3rdParty {
    pname = "libpigpiod";
    buildInputs = [ indilib ];
    meta = with lib; {
      license = licenses.unlicense;
      broken = true;
      platforms = [ ];
    };
  };

  libpktriggercord = buildIndi3rdParty {
    pname = "libpktriggercord";

    postPatch = ''
      substituteInPlace CMakeLists.txt \
        --replace-fail "set (PK_DATADIR /usr/share/pktriggercord)" "set (PK_DATADIR $out/share/pkgtriggercord)"
    '';

    buildInputs = [ indilib ];

    meta = with lib; {
      license = licenses.lgpl3Plus;
      platforms = platforms.linux;
    };
  };

  libplayerone = buildIndi3rdParty {
    pname = "libplayerone";
    postPatch = ''
      substituteInPlace 99-player_one_astronomy.rules \
        --replace-fail "/bin/echo" "${coreutils}/bin/echo" \
        --replace "/bin/sh" "${bash}/bin/sh"
    '';

    buildInputs = [
      stdenv.cc.cc.lib
      libusb1
      systemd
    ];
    nativeBuildInputs = [ autoPatchelfHook ];
    meta = with lib; {
      license = lib.licenses.unfreeRedistributable;
      platforms = with platforms; x86_64 ++ aarch64 ++ arm;
    };
  };

  libqhy = buildIndi3rdParty {
    pname = "libqhy";

    postPatch = ''
      substituteInPlace --replace-fail CMakeLists.txt \
        --replace "/lib/firmware" "lib/firmware"

      substituteInPlace 85-qhyccd.rules \
        --replace-fail "/sbin/fxload" "${fxload}/sbin/fxload" \
        --replace-fail "/lib/firmware" "$out/lib/firmware" \
        --replace-fail "/bin/sleep" "${coreutils}/bin/sleep"

      sed -e 's|-D $env{DEVNAME}|-p $env{BUSNUM},$env{DEVNUM}|' -i 85-qhyccd.rules
    '';

    cmakeFlags = [ "-DQHY_FIRMWARE_INSTALL_DIR=\${CMAKE_INSTALL_PREFIX}/lib/firmware/qhy" ];

    buildInputs = [
      stdenv.cc.cc.lib
      libusb1
    ];
    nativeBuildInputs = [ autoPatchelfHook ];

    meta = with lib; {
      license = lib.licenses.unfreeRedistributable;
      platforms = with platforms; x86_64 ++ aarch64 ++ arm;
    };
  };

  libqsi = buildIndi3rdParty {
    pname = "libqsi";
    buildInputs = [
      libftdi1
      indilib
    ];
    nativeBuildInputs = [ autoPatchelfHook ];
    meta = with lib; {
      license = lib.licenses.unfreeRedistributable;
      platforms = platforms.linux;
    };
  };

  libricohcamerasdk = buildIndi3rdParty {
    pname = "libricohcamerasdk";
    buildInputs = [
      stdenv.cc.cc.lib
      libusb1
    ];
    nativeBuildInputs = [ autoPatchelfHook ];
    meta = with lib; {
      license = lib.licenses.unfreeRedistributable;
      platforms = with platforms; x86_64 ++ i686 ++ arm;
    };
  };

  libsbig = buildIndi3rdParty {
    pname = "libsbig";

    postPatch = ''
      substituteInPlace CMakeLists.txt --replace-fail "/lib/firmware" "lib/firmware"
      substituteInPlace 51-sbig-debian.rules \
        --replace-fail "/sbin/fxload" "${fxload}/sbin/fxload" \
        --replace-fail "/lib/firmware" "$out/lib/firmware"

      sed -e 's|-D $env{DEVNAME}|-p $env{BUSNUM},$env{DEVNUM}|' -i 51-sbig-debian.rules
    '';

    buildInputs = [ libusb1 ];
    nativeBuildInputs = [ autoPatchelfHook ];

    meta = with lib; {
      license = lib.licenses.unfreeRedistributable;
      platforms = with platforms; x86_64 ++ aarch64 ++ arm;
    };
  };

  libstarshootg = buildIndi3rdParty {
    pname = "libstarshootg";
    nativeBuildInputs = [ autoPatchelfHook ];
    meta = with lib; {
      license = lib.licenses.unfreeRedistributable;
      platforms = with platforms; x86_64 ++ aarch64 ++ arm;
    };
  };

  libsvbony = buildIndi3rdParty {
    pname = "libsvbony";
    buildInputs = [
      stdenv.cc.cc.lib
      libusb1
    ];
    nativeBuildInputs = [ autoPatchelfHook ];
    meta = with lib; {
      license = lib.licenses.unfreeRedistributable;
      platforms = with platforms; x86_64 ++ aarch64 ++ arm ++ i686;
    };
  };

  libtoupcam = buildIndi3rdParty {
    pname = "libtoupcam";
    nativeBuildInputs = [ autoPatchelfHook ];
    meta = with lib; {
      license = lib.licenses.unfreeRedistributable;
      platforms = with platforms; x86_64 ++ aarch64 ++ arm;
    };
  };

  libtscam = buildIndi3rdParty {
    pname = "libtscam";
    nativeBuildInputs = [ autoPatchelfHook ];
    meta = with lib; {
      license = lib.licenses.unfreeRedistributable;
      platforms = with platforms; x86_64 ++ aarch64 ++ arm;
    };
  };

in
{

  indi-aagcloudwatcher-ng = buildIndi3rdParty {
    pname = "indi-aagcloudwatcher-ng";
    buildInputs = [ indilib ];
  };

  # libahc-xc needs libdfu, which is not packaged
  # indi-ahp-xc = buildIndi3rdParty {
  #   pname = "indi-ahp-xc";
  #   buildInputs = [ cfitsio indilib libahp-xc libnova zlib ];
  #   meta.platforms = libahp-xc.meta.platforms;
  # };

  indi-aok = buildIndi3rdParty {
    pname = "indi-aok";
    buildInputs = [
      indilib
      libnova
    ];
  };

  indi-apogee = buildIndi3rdParty {
    pname = "indi-apogee";
    buildInputs = [
      cfitsio
      indilib
      libapogee
      zlib
    ];
    meta.platforms = libapogee.meta.platforms;
  };

  indi-armadillo-platypus = buildIndi3rdParty {
    pname = "indi-armadillo-platypus";
    buildInputs = [
      indilib
      libnova
    ];
    postPatch = ''
      substituteInPlace CMakeLists.txt --replace-fail "/lib/udev/rules.d" "lib/udev/rules.d"
    '';
  };

  indi-asi = buildIndi3rdParty {
    pname = "indi-asi";
    buildInputs = [
      cfitsio
      indilib
      libasi
      libusb1
      zlib
    ];
    meta.platforms = libasi.meta.platforms;
  };

  # broken needs pigpio
  indi-asi-power = buildIndi3rdParty {
    pname = "indi-asi-power";
    buildInputs = [ indilib ];
    meta.platforms = [ ];
    meta.broken = true;
  };

  indi-astroasis = buildIndi3rdParty {
    pname = "indi-astroasis";
    buildInputs = [
      cfitsio
      indilib
      libastroasis
      libusb1
      zlib
    ];
    meta.platforms = libastroasis.meta.platforms;
  };

  indi-astrolink4 = buildIndi3rdParty {
    pname = "indi-astrolink4";
    buildInputs = [ indilib ];
  };

  indi-astromechfoc = buildIndi3rdParty {
    pname = "indi-astromechfoc";
    buildInputs = [
      indilib
      zlib
    ];
  };

  indi-atik = buildIndi3rdParty {
    pname = "indi-atik";
    buildInputs = [
      cfitsio
      indilib
      libusb1
      zlib
    ];
    propagatedBuildInputs = [ libatik ];
    meta.platforms = libatik.meta.platforms;
  };

  indi-avalon = buildIndi3rdParty {
    pname = "indi-avalon";
    buildInputs = [
      indilib
      libnova
    ];
  };

  indi-avalonud = buildIndi3rdParty {
    pname = "indi-avalonud";
    buildInputs = [
      indilib
      libnova
      zeromq
    ];
  };

  indi-beefocus = buildIndi3rdParty {
    pname = "indi-beefocus";
    buildInputs = [
      gtest
      indilib
    ];
  };

  indi-bresserexos2 = buildIndi3rdParty {
    pname = "indi-bresserexos2";
    buildInputs = [
      indilib
      libnova
    ];
  };

  indi-celestronaux = buildIndi3rdParty {
    pname = "indi-celestronaux";
    buildInputs = [
      indilib
      gsl
      libnova
      zlib
    ];
  };

  indi-dreamfocuser = buildIndi3rdParty {
    pname = "indi-dreamfocuser";
    buildInputs = [ indilib ];
  };

  indi-dsi = buildIndi3rdParty {
    pname = "indi-dsi";
    buildInputs = [
      gtest
      cfitsio
      indilib
      libusb1
      zlib
    ];

    postPatch = ''
      substituteInPlace CMakeLists.txt \
        --replace-fail "/lib/udev/rules.d" "lib/udev/rules.d" \
        --replace-fail "/lib/firmware" "lib/firmware"
      substituteInPlace 99-meadedsi.rules \
        --replace-fail "/sbin/fxload" "${fxload}/sbin/fxload" \
        --replace-fail "/lib/firmware" "$out/lib/firmware"

      sed -e 's|-D $env{DEVNAME}|-p $env{BUSNUM},$env{DEVNUM}|' -i 99-meadedsi.rules
    '';
  };

  indi-duino = buildIndi3rdParty {
    pname = "indi-duino";
    buildInputs = [
      curl
      indilib
    ];
  };

  indi-eqmod = buildIndi3rdParty {
    pname = "indi-eqmod";
    buildInputs = [
      indilib
      gsl
      gtest
      libahp-gt
      libnova
      zlib
    ];
    meta.platforms = libahp-gt.meta.platforms;
  };

  indi-ffmv = buildIndi3rdParty {
    pname = "indi-ffmv";
    buildInputs = [
      cfitsio
      indilib
      libdc1394
      zlib
    ];
  };

  indi-fishcamp = buildIndi3rdParty {
    pname = "indi-fishcamp";
    buildInputs = [
      cfitsio
      indilib
      libusb1
      zlib
    ];
    propagatedBuildInputs = [ libfishcamp ];
    meta.platforms = libfishcamp.meta.platforms;
  };

  indi-fli = buildIndi3rdParty {
    pname = "indi-fli";
    buildInputs = [
      cfitsio
      indilib
      zlib
    ];
    propagatedBuildInputs = [ libfli ];
    meta.platforms = libfli.meta.platforms;
  };

  indi-gige = buildIndi3rdParty {
    pname = "indi-gige";
    buildInputs = [
      aravis
      cfitsio
      indilib
      glib
      zlib
    ];
  };

  indi-gphoto = buildIndi3rdParty {
    pname = "indi-gphoto";
    buildInputs = [
      cfitsio
      libjpeg
      libraw
      libusb1
      indilib
      zlib
    ];
    propagatedBuildInputs = [ libgphoto2 ];
  };

  indi-gpio = buildIndi3rdParty {
    pname = "indi-gpio";
    buildInputs = [
      indilib
      libgpiod_1
      libnova
      zlib
    ];
  };

  indi-gpsd = buildIndi3rdParty {
    pname = "indi-gpsd";
    buildInputs = [
      indilib
      gpsd
      libnova
      zlib
    ];
  };

  indi-gpsnmea = buildIndi3rdParty {
    pname = "indi-gpsnmea";
    buildInputs = [
      indilib
      libnova
      zlib
    ];
  };

  indi-inovaplx = buildIndi3rdParty {
    pname = "indi-inovaplx";
    buildInputs = [
      cfitsio
      indilib
      zlib
    ];
    propagatedBuildInputs = [ libinovasdk ];
    meta.platforms = libinovasdk.meta.platforms;
  };

  # broken, wants rpicam-apps
  indi-libcamera = buildIndi3rdParty {
    pname = "indi-libcamera";
    buildInputs = [
      boost
      cfitsio
      indilib
      libcamera
      libexif
      libdrm
      libpng
      libusb1
      libraw
      zlib
    ];
    meta.platforms = [ ];
    meta.broken = true;
  };

  indi-limesdr = buildIndi3rdParty {
    pname = "indi-limesdr";
    buildInputs = [
      cfitsio
      indilib
      limesuite
      zlib
    ];
  };

  indi-maxdomeii = buildIndi3rdParty {
    pname = "indi-maxdomeii";
    buildInputs = [
      gtest
      indilib
      libnova
      zlib
    ];
  };

  indi-mgen = buildIndi3rdParty {
    pname = "indi-mgen";
    buildInputs = [
      cfitsio
      indilib
      libftdi1
      zlib
    ];
  };

  indi-mi = buildIndi3rdParty {
    pname = "indi-mi";
    buildInputs = [
      cfitsio
      indilib
      libusb1
      zlib
    ];
    propagatedBuildInputs = [ libmicam ];
  };

  indi-nexdome = buildIndi3rdParty {
    pname = "indi-nexdome";
    buildInputs = [
      indilib
      libnova
      zlib
    ];
  };

  indi-nightscape = buildIndi3rdParty {
    pname = "indi-nightscape";
    buildInputs = [
      cfitsio
      indilib
      libusb1
      libftdi1
      zlib
    ];
  };

  indi-nut = buildIndi3rdParty {
    pname = "indi-nut";
    buildInputs = [
      indilib
      nut
      zlib
    ];
  };

  indi-ocs = buildIndi3rdParty {
    pname = "indi-ocs";
    buildInputs = [
      indilib
      libnova
    ];
  };

  indi-orion-ssg3 = buildIndi3rdParty {
    pname = "indi-orion-ssg3";
    buildInputs = [
      cfitsio
      indilib
      libusb1
      zlib
    ];

    postPatch = ''
      substituteInPlace CMakeLists.txt --replace-fail "/lib/udev/rules.d" "lib/udev/rules.d"
    '';
  };

  indi-pentax = buildIndi3rdParty {
    pname = "indi-pentax";
    buildInputs = [
      cfitsio
      indilib
      libraw
      zlib
    ];
    propagatedBuildInputs = [
      libpktriggercord
      libricohcamerasdk
    ];

    meta.platforms = libricohcamerasdk.meta.platforms;
  };

  indi-playerone = buildIndi3rdParty {
    pname = "indi-playerone";
    buildInputs = [
      cfitsio
      indilib
      libusb1
      zlib
    ];
    propagatedBuildInputs = [ libplayerone ];
    meta.platforms = libplayerone.meta.platforms;
  };

  indi-qhy = buildIndi3rdParty {
    pname = "indi-qhy";
    buildInputs = [
      libqhy
      cfitsio
      indilib
      libnova
      libusb1
      zlib
    ];
    propagatedBuildInputs = [ libqhy ];
    meta.platforms = libqhy.meta.platforms;
  };

  indi-qsi = buildIndi3rdParty {
    pname = "indi-qsi";
    buildInputs = [
      cfitsio
      indilib
      libqsi
      zlib
    ];

    postPatch = ''
      substituteInPlace CMakeLists.txt --replace-fail "/lib/udev/rules.d" "lib/udev/rules.d"
    '';

    meta.platforms = libqsi.meta.platforms;
  };

  indi-rolloffino = buildIndi3rdParty {
    pname = "indi-rolloffino";
    buildInputs = [
      indilib
      libnova
      zlib
    ];
  };

  indi-rpi-gpio = buildIndi3rdParty {
    pname = "indi-rpi-gpio";
    buildInputs = [
      indilib
      libpigpiod
    ];
    meta.platforms = libpigpiod.meta.platforms;
  };

  indi-rtklib = buildIndi3rdParty {
    pname = "indi-rtklib";
    buildInputs = [
      indilib
      libnova
      libpng
      zlib
    ];
  };

  indi-sbig = buildIndi3rdParty {
    pname = "indi-sbig";
    buildInputs = [
      cfitsio
      indilib
      libusb1
      zlib
    ];
    propagatedBuildInputs = [ libsbig ];
  };

  indi-shelyak = buildIndi3rdParty {
    pname = "indi-shelyak";
    buildInputs = [ indilib ];
  };

  indi-spectracyber = buildIndi3rdParty {
    pname = "indi-spectracyber";
    buildInputs = [
      indilib
      libnova
      zlib
    ];
  };

  indi-starbook = buildIndi3rdParty {
    pname = "indi-starbook";
    buildInputs = [
      curl
      indilib
      gtest
      libnova
    ];
  };

  indi-starbook-ten = buildIndi3rdParty {
    pname = "indi-starbook-ten";
    buildInputs = [
      indilib
      libnova
    ];
  };

  indi-svbony = buildIndi3rdParty {
    pname = "indi-svbony";
    buildInputs = [
      cfitsio
      indilib
      zlib
    ];
    propagatedBuildInputs = [ libsvbony ];

    meta.platforms = libsvbony.meta.platforms;
  };

  indi-sx = buildIndi3rdParty {
    pname = "indi-sx";
    buildInputs = [
      cfitsio
      indilib
      libusb1
    ];
    postPatch = ''
      substituteInPlace CMakeLists.txt --replace-fail "/lib/udev/rules.d" "lib/udev/rules.d"
    '';
  };

  indi-talon6 = buildIndi3rdParty {
    pname = "indi-talon6";
    buildInputs = [
      indilib
      libnova
    ];
  };

  indi-toupbase = buildIndi3rdParty {
    pname = "indi-toupbase";
    buildInputs = [
      cfitsio
      indilib
      zlib
    ];
    propagatedBuildInputs = [
      libaltaircam
      libbressercam
      libmallincam
      libmeadecam
      libnncam
      libogmacam
      libomegonprocam
      libstarshootg
      libtoupcam
      libtscam
    ];

    meta.platforms = with lib.platforms; aarch64 ++ x86_64;
  };

  indi-webcam = buildIndi3rdParty {
    pname = "indi-webcam";
    buildInputs = [
      cfitsio
      indilib
      ffmpeg-headless
      zlib
    ];
  };

  indi-weewx-json = buildIndi3rdParty {
    pname = "indi-weewx-json";
    buildInputs = [
      curl
      indilib
    ];
  };

}
