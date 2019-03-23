{ stdenv, fetchFromGitLab, meson, ninja, nasm }:

stdenv.mkDerivation rec {
  pname = "dav1d";
  version = "0.2.1";

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "videolan";
    repo = pname;
    rev = version;
    sha256 = "0diihk7lcdxxbfqp79dpvj14008zfzmayamh4vj310i524lqnkb6";
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
