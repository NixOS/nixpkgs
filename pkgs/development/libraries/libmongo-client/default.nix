{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, glib }:

stdenv.mkDerivation rec {
  pname = "libmongo-client";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "algernon";
    repo = "libmongo-client";
    rev = "${pname}-${version}";
    sha256 = "1cjx06i3gd9zkyvwm2ysjrf0hkhr7bjg3c27s7n0y31j10igfjp0";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ ];
  propagatedBuildInputs = [ glib ];

  postPatch = ''
    # Fix when uses glib in public headers
    sed -i 's/Requires.private/Requires/g' src/libmongo-client.pc.in
  '';

  meta = with lib; {
    homepage = "http://algernon.github.io/libmongo-client/";
    description = "An alternative C driver for MongoDB";
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
