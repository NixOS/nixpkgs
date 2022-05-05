{ pkgs, build-asdf-system, fixup ? pkgs.lib.id, ... }:

with pkgs;
with lib;
with lib.lists;
with lib.strings;

let

  # FIXME: automatically add nativeLibs based on conditions signalled

  extras = {
    "cl+ssl" = pkg: {
      nativeLibs = [ openssl ];
    };
    cl-cffi-gtk-glib = pkg: {
      nativeLibs = [ glib ];
    };
    cl-cffi-gtk-cairo = pkg: {
      nativeLibs = [ cairo ];
    };
    cl-cffi-gtk-gdk = pkg: {
      nativeLibs = [ gtk3 ];
    };
    cl-cffi-gtk-gdk-pixbuf = pkg: {
      nativeLibs = [ gdk-pixbuf ];
    };
    cl-cffi-gtk-pango = pkg: {
      nativeLibs = [ pango ];
    };
    cl-gobject-introspection = pkg: {
      nativeLibs = [ glib gobject-introspection ];
    };
    cl-mysql = pkg: {
      nativeLibs = [ mysql-client ];
    };
    clsql-postgresql = pkg: {
      nativeLibs = [ postgresql.lib ];
    };
    clsql-sqlite3 = pkg: {
      nativeLibs = [ sqlite ];
    };
    cl-webkit2 = pkg: {
      nativeLibs = [ webkitgtk ];
    };
    dbd-mysql = pkg: {
      nativeLibs = [ mysql-client ];
    };
    lla = pkg: {
      nativeLibs = [ openblas ];
    };
    cffi-libffi = pkg: {
      nativeBuildInputs = [ libffi ];
      nativeLibs = [ libffi ];
    };
    cl-rabbit = pkg: {
      nativeBuildInputs = [ rabbitmq-c ];
      nativeLibs = [ rabbitmq-c ];
    };
    trivial-ssh-libssh2 = pkg: {
      nativeLibs = [ libssh2 ];
    };
    sqlite = pkg: {
      nativeLibs = [ sqlite ];
    };
    cl-libuv = pkg: {
      nativeBuildInputs = [ libuv ];
      nativeLibs = [ libuv ];
    };
    cl-liballegro = pkg: {
      # build doesnt fail without this, but fails on runtime
      # weird...
      nativeLibs = [ allegro5 ];
    };
    classimp = pkg: {
      nativeLibs = [ assimp ];
    };
    sdl2 = pkg: {
      nativeLibs = [ SDL2 ];
    };
    lispbuilder-sdl-cffi = pkg: {
      nativeLibs = [ SDL ];
    };
    cl-opengl = pkg: {
      nativeLibs = [ libGL ];
    };
    cl-glu = pkg: {
      nativeLibs = [ libGLU ];
    };
    cl-glut = pkg: {
      nativeLibs = [ freeglut ];
    };
    cl-glfw = pkg: {
      nativeLibs = [ glfw ];
    };
    cl-glfw-opengl-core = pkg: {
      nativeLibs = [ libGL ];
    };
    cl-glfw3 = pkg: {
      nativeLibs = [ glfw ];
    };
    lev = pkg: {
      nativeLibs = [ libev ];
    };
    cl-rdkafka = pkg: {
      nativeBuildInputs = [ rdkafka ];
      nativeLibs = [ rdkafka ];
    };
    cl-async-ssl = pkg: {
      nativeLibs = [ openssl ];
    };
    osicat = pkg: {
      LD_LIBRARY_PATH = "${pkg}/posix/";
    };
    iolib = pkg: {
      nativeBuildInputs = [ libfixposix ];
      nativeLibs = [ libfixposix ];
      systems = [ "iolib" "iolib/os" "iolib/pathnames" ];
    };
  };

  qlpkgs =
    if builtins.pathExists ./imported.nix
    # then filterAttrs (n: v: all (check: !(check n v)) broken) (import ./imported.nix { inherit pkgs; })
    then import ./imported.nix { inherit (pkgs) runCommand fetchzip; pkgs = builtQlpkgs; }
    else {};

  builtQlpkgs = mapAttrs (n: v: build v) qlpkgs;

  build = pkg:
    let
      builtPkg = build-asdf-system pkg;
      withExtras = pkg //
                   (optionalAttrs
                     (hasAttr pkg.pname extras)
                     (extras.${pkg.pname} builtPkg));
      fixedUp = fixup withExtras;
    in build-asdf-system fixedUp;

in builtQlpkgs
