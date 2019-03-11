{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, glib }:

stdenv.mkDerivation rec {
  name = "libmongo-client-0.1.8";

  src = fetchFromGitHub {
    owner = "algernon";
    repo = "libmongo-client";
    rev = name;
    sha256 = "1cjx06i3gd9zkyvwm2ysjrf0hkhr7bjg3c27s7n0y31j10igfjp0";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ ];
  propagatedBuildInputs = [ glib ];

  postPatch = ''
    # Fix when uses glib in public headers
    sed -i 's/Requires.private/Requires/g' src/libmongo-client.pc.in
  '';

  meta = with stdenv.lib; {
    homepage = http://algernon.github.io/libmongo-client/;
    description = "An alternative C driver for MongoDB";
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
