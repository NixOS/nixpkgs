{stdenv, fetchFromGitHub, cmake, torch, protobuf, protobufc}:
stdenv.mkDerivation rec {
  name = "loadcaffe-${version}";
  version = "0.0pre2016.08.01";
  buildInputs = [cmake torch protobuf protobufc];
  src = fetchFromGitHub {
    owner = "szagoruyko";
    repo = "loadcaffe";
    rev = "9be65cf6fa08e9333eae3553f68a8082debe9978";
    sha256 = "0b22hvd9nvjsan2h93nl6y34kkkbs36d0k1zr3csjfb5l13xz0lh";
  };
  meta = {
    inherit version;
    description = ''Torch7 loader for Caffe networks'';
    license = stdenv.lib.licenses.bsd2 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
