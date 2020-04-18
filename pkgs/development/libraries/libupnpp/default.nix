{ fetchgit, stdenv, lib, autoreconfHook, pkg-config, libnpupnp, curl, expat }:

stdenv.mkDerivation rec {
  pname = "libupnpp";
  version = "0.18.0";

  src = fetchgit {
    url = "https://framagit.org/medoc92/libupnpp.git";
    rev = "libupnpp-v${version}";
    sha256 = "sha256-kPT1B3Gej7OdJqsomO1NVLUPsnwIUJNfLjPyjXbjB7k=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config libnpupnp curl expat ];

  meta = {
    description = "higher level C++ API over libnpupnp or libupnp";

    license = "BSD-style";

    homepage = https://framagit.org/medoc92/npupnp;
    platforms = lib.platforms.unix;
  };
}
