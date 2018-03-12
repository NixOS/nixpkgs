{ stdenv, fetchFromGitHub, autoreconfHook, flex }:

stdenv.mkDerivation rec {
  name = "libconfuse-${version}";
  version = "3.2.1";

  src = fetchFromGitHub {
    sha256 = "1pb74wpg1cxz9hpp0p8i1qq6anaq06mh4xljd8dllm653fxvbjdz";
    rev = "v${version}";
    repo = "libconfuse";
    owner = "martinh";
  };

  nativeBuildInputs = [ autoreconfHook flex ];

  enableParallelBuilding = true;

  doCheck = true;

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
