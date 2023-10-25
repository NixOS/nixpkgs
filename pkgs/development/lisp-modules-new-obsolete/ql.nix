{ pkgs, build-asdf-system, fixup ? pkgs.lib.id, ... }:

with pkgs;
with lib;
with lib.lists;
with lib.strings;

let

  # FIXME: automatically add nativeLibs based on conditions signalled

  # Try to keep this list sorted
  extras = {
    cffi-libffi = pkg: {
      nativeBuildInputs = [ libffi ];
      nativeLibs = [ libffi ];
    };
    "cl+ssl" = pkg: {
      nativeLibs = [ openssl_1_1 ];
    };
    "cl-ana.hdf-cffi" = pkg: {
      nativeBuildInputs = [ pkgs.hdf5 ];
      nativeLibs = [ pkgs.hdf5 ];
      NIX_LDFLAGS = [ "-lhdf5" ];
    };
    cl-async-ssl = pkg: {
      nativeLibs = [ openssl_1_1 ];
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
    cl-cairo2 = pkg: {
      nativeLibs = [ cairo ];
    };
    cl-cairo2-xlib = pkg: {
      nativeLibs = [ gtk2-x11 ];
    };
    cl-devil = pkg: {
      nativeBuildInputs = [ pkgs.libdevil ];
      nativeLibs = [ pkgs.libdevil ];
    };
    cl-freeimage = pkg: {
      nativeLibs = [ freeimage ];
    };
    cl-freetype2 = pkg: {
      nativeLibs = [ freetype ];
      nativeBuildInputs = [ freetype ];
      patches = [ ./patches/cl-freetype2-fix-grovel-includes.patch ];
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
    cl-glu = pkg: {
      nativeLibs = [ libGLU ];
    };
    cl-glut = pkg: {
      nativeLibs = [ freeglut ];
    };
    cl-gobject-introspection = pkg: {
      nativeLibs = [ glib gobject-introspection ];
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
    cl-liballegro = pkg: {
      # build doesnt fail without this, but fails on runtime
      # weird...
      nativeLibs = [ allegro5 ];
    };
    cl-libuv = pkg: {
      nativeBuildInputs = [ libuv ];
      nativeLibs = [ libuv ];
    };
    cl-libxml2 = pkg: {
      nativeLibs = [ pkgs.libxml2 ];
    };
    cl-libyaml = pkg: {
      nativeLibs = [ pkgs.libyaml ];
    };
    cl-mysql = pkg: {
      nativeLibs = [ mariadb.client ];
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
    cl-opengl = pkg: {
      nativeLibs = [ libGL ];
    };
    cl-pango = pkg: {
      nativeLibs = [ pango ];
    };
    cl-rabbit = pkg: {
      nativeBuildInputs = [ rabbitmq-c ];
      nativeLibs = [ rabbitmq-c ];
    };
    cl-rdkafka = pkg: {
      nativeBuildInputs = [ rdkafka ];
      nativeLibs = [ rdkafka ];
    };
    cl-readline = pkg: {
      nativeLibs = [ pkgs.readline ];
    };
    cl-rsvg2 = pkg: {
      nativeLibs = [ librsvg ];
    };
    "cl-sat.glucose" = pkg: {
      propagatedBuildInputs = [ pkgs.glucose ];
      patches = [ ./patches/cl-sat.glucose-binary-from-PATH-if-present.patch ];

    };
    "cl-sat.minisat" = pkg: {
      propagatedBuildInputs = [ pkgs.minisat ];
    };
    cl-webkit2 = pkg: {
      nativeLibs = [ webkitgtk ];
    };
    classimp = pkg: {
      nativeLibs = [ assimp ];
      meta.broken = true; # Requires assimp ≤ 5.0.x.
    };
    clsql-postgresql = pkg: {
      nativeLibs = [ postgresql.lib ];
    };
    clsql-sqlite3 = pkg: {
      nativeLibs = [ sqlite ];
    };
    dbd-mysql = pkg: {
      nativeLibs = [ mariadb.client ];
    };
    gsll = pkg: {
      nativeBuildInputs = [ pkgs.gsl ];
      nativeLibs = [ pkgs.gsl ];
    };
    iolib = pkg: {
      nativeBuildInputs = [ libfixposix ];
      nativeLibs = [ libfixposix ];
      systems = [ "iolib" "iolib/os" "iolib/pathnames" ];
    };
    lev = pkg: {
      nativeLibs = [ libev ];
    };
    lispbuilder-sdl-cffi = pkg: {
      nativeLibs = [ SDL ];
    };
    lla = pkg: {
      nativeLibs = [ openblas ];
    };
    mssql = pkg: {
      nativeLibs = [ freetds ];
    };
    osicat = pkg: {
      LD_LIBRARY_PATH = "${pkg}/posix/";
    };
    png = pkg: {
      nativeBuildInputs = [ pkgs.libpng ];
      nativeLibs = [ pkgs.libpng ];
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
    sdl2 = pkg: {
      nativeLibs = [ SDL2 ];
    };
    sqlite = pkg: {
      nativeLibs = [ sqlite ];
    };
    trivial-package-manager = pkg: {
      propagatedBuildInputs = [ pkgs.which ];
    };
    trivial-ssh-libssh2 = pkg: {
      nativeLibs = [ libssh2 ];
    };
    zmq = pkg: {
      nativeBuildInputs = [ pkgs.zeromq ];
      nativeLibs = [ pkgs.zeromq ];
    };
  };

  qlpkgs =
    lib.optionalAttrs (builtins.pathExists ./imported.nix)
      (import ./imported.nix { inherit (pkgs) runCommand fetchzip; pkgs = builtQlpkgs; });

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
