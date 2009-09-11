{stdenv, fetchurl, cmake, taglib}:

stdenv.mkDerivation {
  name = "taglib-extras-0.1.7";
  src = fetchurl {
    url = http://www.kollide.net/~jefferai/taglib-extras-0.1.7.tar.gz;
    sha256 = "0n8nq218d2cni9sf67kggrzv1h60hn395yy99fdj6i6n97mwcsr0";
  };
  buildInputs = [ cmake taglib ];
}
