{ stdenv, fetchFromGitHub, autoreconfHook, flex }:

stdenv.mkDerivation rec {
  name = "libconfuse-${version}";
  version = "3.2.2";

  src = fetchFromGitHub {
    sha256 = "0djjq7j9iiyqxqqrlzm476xkibjasqvgzjwkalgj1l3f2smi53aw";
    rev = "v${version}";
    repo = "libconfuse";
    owner = "martinh";
  };

  nativeBuildInputs = [ autoreconfHook flex ];

  enableParallelBuilding = true;

  # On darwin the tests depend on the installed libraries because of install_name.
  doInstallCheck = true;
  installCheckTarget = "check";

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Small configuration file parser library for C";
    longDescription = ''
      libConfuse (previously libcfg) is a configuration file parser library
      written in C. It supports sections and (lists of) values, as well as
      some other features. It makes it very easy to add configuration file
      capability to a program using a simple API.

      The goal of libConfuse is not to be the configuration file parser library
      with a gazillion of features. Instead, it aims to be easy to use and
      quick to integrate with your code.
    '';
    license = licenses.isc;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
