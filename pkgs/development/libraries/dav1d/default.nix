{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, nasm
, pkg-config
, xxHash
, withTools ? false # "dav1d" binary
, withExamples ? false
, SDL2 # "dav1dplay" binary
, useVulkan ? false
, libplacebo
, vulkan-loader
, vulkan-headers

  # for passthru.tests
, ffmpeg
, gdal
, handbrake
, libavif
, libheif
}:

assert useVulkan -> withExamples;

stdenv.mkDerivation rec {
  pname = "dav1d";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "videolan";
    repo = pname;
    rev = version;
    hash = "sha256-PBFQrGGP7hKNMuwkl7q/7/C7v41xqdOYW+pJ70fI4Uo=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ meson ninja nasm pkg-config ];
  # TODO: doxygen (currently only HTML and not build by default).
  buildInputs = [ xxHash ]
    ++ lib.optional withExamples SDL2
    ++ lib.optionals useVulkan [ libplacebo vulkan-loader vulkan-headers ];

  mesonFlags = [
    "-Denable_tools=${lib.boolToString withTools}"
    "-Denable_examples=${lib.boolToString withExamples}"
  ];

  doCheck = true;

  passthru.tests = {
    inherit
      ffmpeg
      gdal
      handbrake
      libavif
      libheif;
  };

  meta = with lib; {
    description = "Cross-platform AV1 decoder focused on speed and correctness";
    longDescription = ''
      The goal of this project is to provide a decoder for most platforms, and
      achieve the highest speed possible to overcome the temporary lack of AV1
      hardware decoder. It supports all features from AV1, including all
      subsampling and bit-depth parameters.
    '';
    inherit (src.meta) homepage;
    changelog = "https://code.videolan.org/videolan/dav1d/-/tags/${version}";
    # More technical: https://code.videolan.org/videolan/dav1d/blob/${version}/NEWS
    license = licenses.bsd2;
    platforms = platforms.unix ++ platforms.windows;
    maintainers = with maintainers; [ primeos ];
  };
}
