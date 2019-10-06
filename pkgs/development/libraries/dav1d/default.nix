{ stdenv, fetchFromGitLab
, meson, ninja, nasm, pkgconfig
, withTools ? false, SDL2
, useVulkan ? false, libplacebo, vulkan-loader, vulkan-headers
}:

assert useVulkan -> withTools;

stdenv.mkDerivation rec {
  pname = "dav1d";
  version = "0.4.0";

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "videolan";
    repo = pname;
    rev = version;
    sha256 = "1fbalfzw8j00vwbrh9h8kjdx6h99dr10vmvbpg3rhsspmxq9h66h";
  };

  nativeBuildInputs = [ meson ninja nasm pkgconfig ];
  # TODO: doxygen (currently only HTML and not build by default).
  buildInputs = stdenv.lib.optional withTools SDL2
    ++ stdenv.lib.optionals useVulkan [ libplacebo vulkan-loader vulkan-headers ];

  mesonFlags= [
    "-Denable_tools=${stdenv.lib.boolToString withTools}"
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
