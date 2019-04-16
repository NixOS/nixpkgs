{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, glib, libev, libevent, tevent, talloc }:

let
  name = "libverto-${version}";
  version = "0.2.6";
in
stdenv.mkDerivation {
  inherit name;
  inherit version;

  src = fetchFromGitHub {
    owner = "latchset";
    repo = "libverto";
    rev = version;
    sha256 = "1wis97l2f265bq6ps1b4yjblll7pa2xsckq3kjblv1djg71brmbr";
  };

  patches = [ ./libverto-0.2.6-exec-prefix.patch ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ pkgconfig glib libev libevent tevent talloc ];

  meta = with stdenv.lib; {
    description = "Main loop abstraction library";
    longDescription = ''
      libverto exists to solve an important problem: many applications and
      libraries are unable to write asynchronous code because they are unable to
      pick an event loop. This is particularly true of libraries who want to be
      useful to many applications who use loops that do not integrate with one
      another or which use home-grown loops. libverto provides a loop-neutral
      async api which allows the library to expose asynchronous interfaces and
      offload the choice of the main loop to the application.
    '';
    homepage = https://github.com/latchset/libverto/;
    license = licenses.mit;
    maintainers = [ maintainers.e-user ];
  };
}
