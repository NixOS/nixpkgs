{ pkgs, build-asdf-system, fixup ? pkgs.lib.id, ... }:

with pkgs;
with lib;
with lib.lists;
with lib.strings;

let

  # FIXME: automatically add nativeLibs based on conditions signalled

  extras = {
    "cl+ssl" = pkg: {
      nativeLibs = [ openssl_1_1 ];
    };
    cl-cffi-gtk-glib = pkg: {
      nativeLibs = [ glib ];
    };
    cl-cffi-gtk-cairo = pkg: {
      nativeLibs = [ cairo ];
    };
    cl-cairo2 = pkg: {
      nativeLibs = [ cairo ];
    };
    cl-cairo2-xlib = pkg: {
      nativeLibs = [ gtk2-x11 ];
    };
    cl-freetype2 = pkg: {
      nativeLibs = [ freetype ];
      nativeBuildInputs = [ freetype ];
      patches = [ ./patches/cl-freetype2-fix-grovel-includes.patch ];
    };
    cl-pango = pkg: {
      nativeLibs = [ pango ];
    };
    cl-gtk2-gdk = pkg: {
      nativeLibs = [ gtk2-x11 ];
    };
    cl-gtk2-glib = pkg: {
      nativeLibs = [ glib ];
    };
    cl-gtk2-pango = pkg: {
      nativeLibs = [ pango ];
    };
    cl-rsvg2 = pkg: {
      nativeLibs = [ librsvg ];
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
      nativeLibs = [ mariadb.client ];
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
      nativeLibs = [ mariadb.client ];
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
    mssql = pkg: {
      nativeLibs = [ freetds ];
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
    cl-ode = pkg: {
      nativeLibs = let
        ode' = ode.overrideAttrs (o: {
          configureFlags = [
            "--enable-shared"
            "--enable-double-precision"
          ];
        });
      in [ ode' ];
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
      nativeLibs = [ openssl_1_1 ];
    };
    osicat = pkg: {
      LD_LIBRARY_PATH = "${pkg}/posix/";
    };
    iolib = pkg: {
      nativeBuildInputs = [ libfixposix ];
      nativeLibs = [ libfixposix ];
      systems = [ "iolib" "iolib/os" "iolib/pathnames" ];
    };
    "cl-ana.hdf-cffi" = pkg: {
      nativeBuildInputs = [ pkgs.hdf5 ];
      nativeLibs = [ pkgs.hdf5 ];
      NIX_LDFLAGS = [ "-lhdf5" ];
    };
    gsll = pkg: {
      nativeBuildInputs = [ pkgs.gsl ];
      nativeLibs = [ pkgs.gsl ];
    };
    cl-libyaml = pkg: {
      nativeLibs = [ pkgs.libyaml ];
    };
    cl-libxml2 = pkg: {
      nativeLibs = [ pkgs.libxml2 ];
    };
    cl-readline = pkg: {
      nativeLibs = [ pkgs.readline ];
    };
    pzmq = pkg: {
      nativeBuildInputs = [ pkgs.zeromq ];
      nativeLibs = [ pkgs.zeromq ];
    };
    pzmq-compat = pkg: {
      nativeBuildInputs = [ pkgs.zeromq ];
      nativeLibs = [ pkgs.zeromq ];
    };
    pzmq-examples = pkg: {
      nativeBuildInputs = [ pkgs.zeromq ];
      nativeLibs = [ pkgs.zeromq ];
    };
    pzmq-test = pkg: {
      nativeBuildInputs = [ pkgs.zeromq ];
      nativeLibs = [ pkgs.zeromq ];
    };
    trivial-package-manager = pkg: {
      propagatedBuildInputs = [ pkgs.which ];
    };
    "cl-sat.glucose" = pkg: {
      propagatedBuildInputs = [ pkgs.glucose ];
      patches = [ ./patches/cl-sat.glucose-binary-from-PATH-if-present.patch ];

    };
  };

  qlpkgs =
    if builtins.pathExists ./imported.nix
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
