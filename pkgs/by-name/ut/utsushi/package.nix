{
  lib,
  stdenv,
  writeScriptBin,
  fetchpatch,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  autoconf-archive,
  libxslt,
  boost,
  gtkmm2,
  imagemagick,
  sane-backends,
  tesseract4,
  udev,
  libusb1,
  withNetworkScan ? false,
  utsushi-networkscan,
}:

let
  fakegit = writeScriptBin "git" ''
    #! ${stdenv.shell} -e
    if [ "$1" = "describe" ]; then
      [ -r .rev ] && cat .rev || true
    fi
  '';

in
stdenv.mkDerivation rec {
  pname = "imagescan";
  version = "3.65.0";

  src = fetchFromGitLab {
    owner = "utsushi";
    repo = "imagescan";
    rev = version;
    hash = "sha256-CrN9F/WJKmlDN7eozEHtKgGUQBWVwTqwjnrfiATk7lI=";
  };

  patches = [
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-gfx/iscan/files/iscan-3.63.0-autoconf-2.70.patch?id=4fe8a9e6c60f9163cadad830ba4935c069c67b10";
      hash = "sha256-2V4cextjcEQrywe4tvvD5KaVYdXnwdNhTiY/aSNx3mM=";
    })
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-gfx/iscan/files/iscan-3.61.0-imagemagick-7.patch?id=985c92af4730d864e86fa87746185b0246e9db93";
      hash = "sha256-dfdVMp3ZfclYeRxYjMIvl+ZdlLn9S+IwQ+OmlHW8318=";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/archlinux/svntogit-community/b3046e0e78b95440f135fcadb19a9eb531729a58/trunk/boost-1.74.patch";
      hash = "sha256-W8R1l7ZPcsfiIy1QBJvh0M8du0w1cnTg3PyAz65v4rE=";
    })
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-gfx/iscan/files/iscan-3.65.0-sane-backends-1.1.patch?id=dec60bb6900d6ebdaaa6aa1dcb845b30b739f9b5";
      hash = "sha256-AmMZ+/lrUMR7IU+S8MEn0Ji5pqOiD6izFJBsJ0tCCCw=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    autoconf-archive
    fakegit
    libxslt
  ];

  buildInputs = [
    boost.dev
    gtkmm2.dev
    imagemagick
    sane-backends
    udev.dev
    libusb1.dev
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=deprecated-declarations"
    "-Wno-error=parentheses"
    "-Wno-error=unused-variable"
  ];

  postPatch = ''
    # create fake udev and sane config
    mkdir -p $out/etc/{sane.d,udev/rules.d}
    touch $out/etc/sane.d/dll.conf

    # absolute paths to convert & tesseract
    sed -i '/\[AC_DEFINE(\[HAVE_IMAGE_MAGICK\], \[1\])/a \ MAGICK_CONVERT="${imagemagick}/bin/convert"' configure.ac
    substituteInPlace filters/magick.cpp \
      --replace 'convert ' '${imagemagick}/bin/convert '
    substituteInPlace filters/reorient.cpp \
      --replace '"tesseract' '"${tesseract4}/bin/tesseract'
    substituteInPlace filters/get-text-orientation \
      --replace '=tesseract' '=${tesseract4}/bin/tesseract'
  '';

  configureFlags = [
    "--with-boost-libdir=${boost}/lib"
    "--with-sane-confdir=${placeholder "out"}/etc/sane.d"
    "--with-udev-confdir=${placeholder "out"}/etc/udev"
    "--with-gtkmm"
    "--with-jpeg"
    "--with-magick"
    "--with-magick-pp"
    "--with-sane"
    "--with-tiff"
  ];

  installFlags = [ "SANE_BACKENDDIR=${placeholder "out"}/lib/sane" ];

  enableParallelBuilding = true;

  doInstallCheck = true;

  postInstall = lib.optionalString withNetworkScan ''
    ln -s ${utsushi-networkscan}/libexec/utsushi/networkscan $out/libexec/utsushi
  '';

  meta = with lib; {
    description = "SANE utsushi backend for some Epson scanners";
    mainProgram = "utsushi";
    longDescription = ''
      ImageScanV3 (aka utsushi) scanner driver. Non-free plugins are not
      included, so no network support. To use the SANE backend, in
      <literal>/etc/nixos/configuration.nix</literal>:

      <literal>
      hardware.sane = {
        enable = true;
        extraBackends = [ pkgs.utsushi ];
      };
      services.udev.packages = [ pkgs.utsushi ];
      </literal>

      Supported hardware:
      DS-1610, DS-1630, DS-1660W, DS-310, DS-320, DS-360W, DS-40, DS-410,
      DS-50000, DS-510, DS-520, DS-530, DS-535, DS-535H, DS-5500, DS-560,
      DS-570W, DS-575W, DS-60000, DS-6500, DS-70, DS-70000, DS-7500, DS-760,
      DS-770, DS-775, DS-780N, DS-80W, DS-860, EC-4020 Series, EC-4030 Series,
      EC-4040 Series, EP-10VA Series, EP-30VA Series, EP-708A Series, EP-709A
      Series, EP-710A Series, EP-711A Series, EP-712A Series, EP-808A Series,
      EP-810A Series, EP-811A Series, EP-812A Series, EP-879A Series, EP-880A
      Series, EP-881A Series, EP-882A Series, EP-978A3 Series, EP-979A3 Series,
      EP-982A3 Series, EP-M570T Series, ES-200, ES-300W, ES-300WR, ES-400,
      ES-50, ES-50, ES-500W, ES-500WR, ES-55R, ES-60W, ES-60WB, ES-60WW,
      ES-65WR, ET-16500 Series, ET-2500 Series, ET-2550 Series, ET-2600 Series,
      ET-2610 Series, ET-2650 Series, ET-2700 Series, ET-2710 Series, ET-2720
      Series, ET-2750 Series, ET-2760 Series, ET-3600 Series, ET-3700 Series,
      ET-3710 Series, ET-3750 Series, ET-3760 Series, ET-4500 Series, ET-4550
      Series, ET-4700 Series, ET-4750 Series, ET-4760 Series, ET-7700 Series,
      ET-7750 Series, ET-8700 Series, ET-M2140 Series, ET-M2170 Series,
      ET-M3140 Series, ET-M3170 Series, ET-M3180 Series, EW-052A Series,
      EW-452A Series, EW-M5071FT Series, EW-M571T Series, EW-M630T Series,
      EW-M660FT Series, EW-M670FT Series, EW-M770T Series, EW-M970A3T Series,
      FF-640, FF-680W, GT-S650, L1455 Series, L220 Series, L222 Series, L3050
      Series, L3060 Series, L3070 Series, L3100 Series, L3110 Series, L3150
      Series, L3160 Series, L360 Series, L362 Series, L364 Series, L365 Series,
      L366 Series, L375 Series, L380 Series, L382 Series, L385 Series, L386
      Series, L395 Series, L396 Series, L405 Series, L4150 Series, L4160
      Series, L455 Series, L475 Series, L485 Series, L486 Series, L495 Series,
      L5190 Series, L565 Series, L566 Series, L575 Series, L605 Series, L6160
      Series, L6170 Series, L6190 Series, L655 Series, L7160 Series, L7180
      Series, LX-10000F, LX-10000FK, LX-10010MF, LX-7000F, M2140 Series, M2170
      Series, M3140 Series, M3170 Series, M3180 Series, PX-048A Series, PX-049A
      Series, PX-M160T Series, PX-M270FT Series, PX-M270T Series, PX-M380F,
      PX-M381FL, PX-M5080F Series, PX-M5081F Series, PX-M680F Series, PX-M7050
      Series, PX-M7050FP, PX-M7050FX, PX-M7070FX, PX-M7110F, PX-M7110FP,
      PX-M780F Series, PX-M781F Series, PX-M840FX, PX-M860F, PX-M880FX,
      PX-M884F, PX-M885F, PX-M886FL, Perfection V19, Perfection V39, ST-2000
      Series, ST-3000 Series, ST-4000 Series, ST-M3000 Series, WF-2750 Series,
      WF-2760 Series, WF-2810 Series, WF-2830 Series, WF-2850 Series, WF-2860
      Series, WF-3720 Series, WF-3730 Series, WF-4720 Series, WF-4730 Series,
      WF-4740 Series, WF-6530 Series, WF-6590 Series, WF-7710 Series, WF-7720
      Series, WF-8510 Series, WF-8590 Series, WF-C17590 Series, WF-C20590
      Series, WF-C5710 Series, WF-C5790 Series, WF-C5790BA, WF-C579R Series,
      WF-C579RB, WF-C8610 Series, WF-C8690 Series, WF-C8690B, WF-C869R Series,
      WF-M20590 Series, WF-M5799 Series, WF-R8590 Series, XP-2100 Series,
      XP-220 Series, XP-230 Series, XP-235 Series, XP-240 Series, XP-243 245
      247 Series, XP-255 257 Series, XP-3100 Series, XP-332 335 Series, XP-340
      Series, XP-342 343 345 Series, XP-352 355 Series, XP-4100 Series, XP-430
      Series, XP-432 435 Series, XP-440 Series, XP-442 445 Series, XP-452 455
      Series, XP-5100 Series, XP-530 Series, XP-540 Series, XP-6000 Series,
      XP-6100 Series, XP-630 Series, XP-640 Series, XP-7100 Series, XP-830
      Series, XP-8500 Series, XP-8600 Series, XP-900 Series, XP-960 Series,
      XP-970 Series
    '';
    homepage = "https://gitlab.com/utsushi/imagescan";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      wucke13
      maxwilson
    ];
    platforms = platforms.linux;
  };
}
