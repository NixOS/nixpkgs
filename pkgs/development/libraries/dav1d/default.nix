{ stdenv, fetchFromGitLab, fetchpatch
, meson, ninja, nasm, pkgconfig
, withTools ? false # "dav1d" binary
, withExamples ? false, SDL2 # "dav1dplay" binary
, useVulkan ? false, libplacebo, vulkan-loader, vulkan-headers
}:

assert useVulkan -> withExamples;

stdenv.mkDerivation rec {
  pname = "dav1d";
  version = "0.6.0";

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "videolan";
    repo = pname;
    rev = version;
    sha256 = "1gr859xzbqrsp892v9zzzgrg8smnnzgc1jmb68qzl54a4g6jrxm0";
  };

  patches = [
    (fetchpatch {
      url = "https://code.videolan.org/videolan/dav1d/-/commit/e04227c5f6729b460e0b8e5fb52eae2d5acd15ef.patch";
      sha256 = "18mpvwviqx0x9k6av98vgpjqlzcjd89g8496zsbf57bw5dadij3l";
    })
  ];

  nativeBuildInputs = [ meson ninja nasm pkgconfig ];
  # TODO: doxygen (currently only HTML and not build by default).
  buildInputs = stdenv.lib.optional withExamples SDL2
    ++ stdenv.lib.optionals useVulkan [ libplacebo vulkan-loader vulkan-headers ];

  mesonFlags= [
    "-Denable_tools=${stdenv.lib.boolToString withTools}"
    "-Denable_examples=${stdenv.lib.boolToString withExamples}"
  ];

  meta = with stdenv.lib; {
    description = "A cross-platform AV1 decoder focused on speed and correctness";
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
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos ];
  };
}
