{lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake

# for passthru.tests
, gst_all_1
, mpd
, ocamlPackages
, vlc
}:

stdenv.mkDerivation rec {
  pname = "faad2";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "knik0";
    repo = "faad2";
    rev = version;
    hash = "sha256-fp8RGG9HQOcyudTA9osGaI3oVIY8vo8vhJtd04+wNKc=";
  };

  patches = [
    # i686Linux packports
    # TODO: remove with next release
    (fetchpatch {
      name = "lrintf-p1.patch";
      url = "https://github.com/knik0/faad2/commit/1001f9576cbb29242671c489cd861de61cfe08e2.patch";
      hash = "sha256-du3oIbtaSU0ZhzMyMmIBHA6lndImA0tmT5D8pK8r49g=";
    })
    (fetchpatch {
      name = "lrintf-p2.patch";
      url = "https://github.com/knik0/faad2/commit/047fd22172a7ff6974b9ac6ca7e4ffdb1944f2e0.patch";
      hash = "sha256-F7VXjtiDbii2oBKuJHZbKSsYGyO+rolPk8KjcvPIRsw=";
    })
    (fetchpatch {
      name = "lrintf-p3.patch";
      url = "https://github.com/knik0/faad2/commit/2c1eebc89dd21ab25c24b664762515af39bd9700.patch";
      hash = "sha256-MSd7dU5IxxpkqCGs1vTvMtOMz6CnY2nXt+w4mj0yd60=";
    })
  ];

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = lib.optionals (!stdenv.hostPlatform.isStatic) [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  passthru.tests = {
    inherit mpd vlc;
    inherit (gst_all_1) gst-plugins-bad;
    ocaml-faad = ocamlPackages.faad;
  };

  meta = with lib; {
    description = "An open source MPEG-4 and MPEG-2 AAC decoder";
    homepage = "https://sourceforge.net/projects/faac/";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ codyopel ];
    mainProgram = "faad";
    platforms   = platforms.all;
  };
}
