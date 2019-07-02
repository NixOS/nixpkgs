{ stdenv, fetchFromGitLab }:

stdenv.mkDerivation rec {
  pname = "olm";
  version = "3.1.3";

  meta = {
    description = "Implements double cryptographic ratchet and Megolm ratchet";
    license = stdenv.lib.licenses.asl20;
    homepage = https://matrix.org/git/olm/about;
    platforms = with stdenv.lib.platforms; darwin ++ linux;
  };

  src = fetchFromGitLab {
    domain = "gitlab.matrix.org";
    owner = "matrix-org";
    repo = "olm";
    rev = "ebd3ba6cc17862aefc9cb3299d60aeae953cc143"; # can't seem to specify the tag?
    sha256 = "19lpdhl6qvc8arahy4z0989q92paq68bd8a44x2ynwvppzhv37k2";
  };

  doCheck = true;
  checkTarget = "test";

  # requires optimisation but memory operations are compiled with -O0
  hardeningDisable = ["fortify"];

  makeFlags = if stdenv.cc.isClang then [ "CC=cc" ] else null;

  installFlags = "PREFIX=$(out)";
}
