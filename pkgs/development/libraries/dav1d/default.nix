{ stdenv, fetchFromGitLab
, meson, ninja, nasm, pkgconfig
, withTools ? false # "dav1d" binary
, withExamples ? false, SDL2 # "dav1dplay" binary
, useVulkan ? false, libplacebo, vulkan-loader, vulkan-headers
}:

assert useVulkan -> withExamples;

stdenv.mkDerivation rec {
  pname = "dav1d";
  version = "0.5.1";

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "videolan";
    repo = pname;
    rev = version;
    sha256 = "08cgccp7xvwn24w9iab4fzi18x3m6xyvvnz36qf7clcz0aqbfb9w";
  };

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
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos ];
  };
}
