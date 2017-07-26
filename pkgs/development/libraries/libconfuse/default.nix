{ stdenv, fetchFromGitHub, autoreconfHook, flex }:

stdenv.mkDerivation rec {
  name = "libconfuse-${version}";
  version = "3.0";

  src = fetchFromGitHub {
    sha256 = "0021768bxqdxn84yaipncgi64889zrhc0r4ifmlfxirwq101dgr5";
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
    maintainers = with maintainers; [ nckx ];
  };
}
