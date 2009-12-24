{stdenv, fetchurl, cmake, taglib}:

stdenv.mkDerivation {
  name = "taglib-extras-1.0.1";
  src = fetchurl {
    url = http://www.kollide.net/~jefferai/taglib-extras-1.0.1.tar.gz;
    sha256 = "0cln49ws9svvvals5fzxjxlzqm0fzjfymn7yfp4jfcjz655nnm7y";
  };
  buildInputs = [ cmake taglib ];
}
