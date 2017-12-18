{ stdenv, lib, fetchFromGitHub, autoreconfHook, pkgconfig
, libdrm, libva_1, libva_2
}:

let
  generic = sha256: vaLib: stdenv.mkDerivation rec {
    name = "libva-utils-${version}";
    inherit (vaLib) version;

    src = fetchFromGitHub {
      owner  = "01org";
      repo   = "libva-utils";
      rev    = version;
      sha256 = "02n51cvp8bzzjk4fargwvgh7z71y8spg24hqgaawbp3p3ahh7xxi";
    };

    nativeBuildInputs = [ autoreconfHook pkgconfig ];

    buildInputs = [ libdrm vaLib ];

    enableParallelBuilding = true;

    meta = with stdenv.lib; {
      description = "VAAPI tools: Video Acceleration API";
      homepage = http://www.freedesktop.org/wiki/Software/vaapi;
      license = licenses.mit;
      maintainers = with maintainers; [ garbas ];
      platforms = platforms.unix;
    };
  };

in {
  # libva-utils 1.8.3 requires libva 2.0.0+
  libva-utils_1 = generic "0pxd9v783p9zh8a9zyi6kaknsbjd4s6lxcyaqqlrbkn1n4yq96ai" libva_2;
  libva-utils_2 = generic "02n51cvp8bzzjk4fargwvgh7z71y8spg24hqgaawbp3p3ahh7xxi" libva_2;
}
