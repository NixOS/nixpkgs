{ stdenv, lib, fetchFromGitHub, autoreconfHook, pkgconfig
, libXext, libdrm, libXfixes, wayland, libffi, libX11
, mesa_noglu
}:

let
  v1Version = "1.8.3";
  v1Sum = "0zqbk02h4jl5v0b141wmi5375k2yplklmm6hv4c75aarlxr7vgms";

  v2Version = "2.0.0";
  v2Sum = "1x8rlmv5wfqjz3j87byrxb4d9vp5b4lrrin2fx254nwl3aqy15hy";

  generic = version: sha256: minimal: stdenv.mkDerivation rec {
    name = "libva-${lib.optionalString (!minimal) "full-"}${version}";

    src = fetchFromGitHub {
      owner  = "01org";
      repo   = "libva";
      rev    = version;
      inherit sha256;
    };

    outputs = [ "dev" "out" ];

    nativeBuildInputs = [ autoreconfHook pkgconfig ];

    buildInputs = [ libdrm ]
      ++ lib.optionals (!minimal) [ libX11 libXext libXfixes wayland libffi mesa_noglu ];
    # TODO: share libs between minimal and !minimal - perhaps just symlink them

    enableParallelBuilding = true;

    configureFlags = [
      "--with-drivers-path=${mesa_noglu.driverLink}/lib/dri"
    ] ++ lib.optionals (!minimal) [ "--enable-glx" ];

    installFlags = [
      "dummy_drv_video_ladir=$(out)/lib/dri"
    ];

    passthru = { inherit version; };

    meta = with stdenv.lib; {
      description = "VAAPI library: Video Acceleration API";
      homepage = http://www.freedesktop.org/wiki/Software/vaapi;
      license = licenses.mit;
      maintainers = with maintainers; [ garbas ];
      platforms = platforms.unix;
    };
  };

in {
  libva_1      = generic v1Version v1Sum true;
  libva_2      = generic v2Version v2Sum true;
  libva-full_1 = generic v1Version v1Sum false;
  libva-full_2 = generic v2Version v2Sum false;
}
