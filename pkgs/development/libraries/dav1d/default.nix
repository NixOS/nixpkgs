{ stdenv, fetchFromGitLab, meson, ninja, nasm }:

stdenv.mkDerivation rec {
  pname = "dav1d";
  version = "0.3.0";

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "videolan";
    repo = pname;
    rev = version;
    sha256 = "08vysa3naqjfvld9w1k6l6hby4xfn4l2gvnfnan498g5nss4050h";
  };

  nativeBuildInputs = [ meson ninja nasm ];
  # TODO: doxygen (currently only HTML and not build by default).

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
