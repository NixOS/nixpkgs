{ stdenv, fetchFromGitHub, autoreconfHook, zlib }:

stdenv.mkDerivation rec {
  pname = "android-image-utils";
  version = "2012-08-08";

  src = fetchFromGitHub {
    owner = "freesmartphone";
    repo = "utilities";
    rev = "1097722a3e5c92e6bef32c1c5eb75f199411c944";
    sha256 = "16qwiazik6yqnp2bdrmg603ddz62xk75xqjn5272c4mw5f7kv2q1";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ zlib ];

  sourceRoot = "source/android/image-utils";

  meta = with stdenv.lib; {
    description = "extract parts from Android boot.img images";
    inherit (src.meta) homepage;
    license = licenses.bsd3;
    maintainers = with maintainers; [ magnetophon ];
    platforms = platforms.linux;
  };
}
