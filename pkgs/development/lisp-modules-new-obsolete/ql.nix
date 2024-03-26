{ pkgs, build-asdf-system, fixup ? pkgs.lib.id, ... }:

let
  inherit (pkgs) lib;

  # FIXME: automatically add nativeLibs based on conditions signalled

  # Try to keep this list sorted
  extras = {
    cffi-libffi = pkg: {
      nativeBuildInputs = [ pkgs.libffi ];
      nativeLibs = [ pkgs.libffi ];
    };
    "cl+ssl" = pkg: {
      nativeLibs = [ pkgs.openssl_1_1 ];
    };
    "cl-ana.hdf-cffi" = pkg: {
      nativeBuildInputs = [ pkgs.hdf5 ];
      nativeLibs = [ pkgs.hdf5 ];
      NIX_LDFLAGS = [ "-lhdf5" ];
    };
    cl-async-ssl = pkg: {
      nativeLibs = [ pkgs.openssl_1_1 ];
    };
    cl-cffi-gtk-glib = pkg: {
      nativeLibs = [ pkgs.glib ];
    };
    cl-cffi-gtk-cairo = pkg: {
      nativeLibs = [ pkgs.cairo ];
    };
    cl-cffi-gtk-gdk = pkg: {
      nativeLibs = [ pkgs.gtk3 ];
    };
    cl-cffi-gtk-gdk-pixbuf = pkg: {
      nativeLibs = [ pkgs.gdk-pixbuf ];
    };
    cl-cffi-gtk-pango = pkg: {
      nativeLibs = [ pkgs.pango ];
    };
    cl-cairo2 = pkg: {
      nativeLibs = [ pkgs.cairo ];
    };
    cl-cairo2-xlib = pkg: {
      nativeLibs = [ pkgs.gtk2-x11 ];
    };
    cl-devil = pkg: {
      nativeBuildInputs = [ pkgs.libdevil ];
      nativeLibs = [ pkgs.libdevil ];
    };
    cl-freeimage = pkg: {
      nativeLibs = [ pkgs.freeimage ];
    };
    cl-freetype2 = pkg: {
      nativeLibs = [ pkgs.freetype ];
      nativeBuildInputs = [ pkgs.freetype ];
      patches = [ ./patches/cl-freetype2-fix-grovel-includes.patch ];
    };
    cl-glfw = pkg: {
      nativeLibs = [ pkgs.glfw ];
    };
    cl-glfw-opengl-core = pkg: {
      nativeLibs = [ pkgs.libGL ];
    };
    cl-glfw3 = pkg: {
      nativeLibs = [ pkgs.glfw ];
    };
    cl-glu = pkg: {
      nativeLibs = [ pkgs.libGLU ];
    };
    cl-glut = pkg: {
      nativeLibs = [ pkgs.freeglut ];
    };
    cl-gobject-introspection = pkg: {
      nativeLibs = [ pkgs.glib pkgs.gobject-introspection ];
    };
    cl-gtk2-gdk = pkg: {
      nativeLibs = [ pkgs.gtk2-x11 ];
    };
    cl-gtk2-glib = pkg: {
      nativeLibs = [ pkgs.glib ];
    };
    cl-gtk2-pango = pkg: {
      nativeLibs = [ pkgs.pango ];
    };
    cl-liballegro = pkg: {
      # build doesnt fail without this, but fails on runtime
      # weird...
      nativeLibs = [ pkgs.allegro5 ];
    };
    cl-libuv = pkg: {
      nativeBuildInputs = [ pkgs.libuv ];
      nativeLibs = [ pkgs.libuv ];
    };
    cl-libxml2 = pkg: {
      nativeLibs = [ pkgs.libxml2 ];
    };
    cl-libyaml = pkg: {
      nativeLibs = [ pkgs.libyaml ];
    };
    cl-mysql = pkg: {
      nativeLibs = [ pkgs.mariadb.client ];
    };
    cl-ode = pkg: {
      nativeLibs = let
        ode' = pkgs.ode.overrideAttrs (o: {
          configureFlags = [
            "--enable-shared"
            "--enable-double-precision"
          ];
        });
      in [ ode' ];
    };
    cl-opengl = pkg: {
      nativeLibs = [ pkgs.libGL ];
    };
    cl-pango = pkg: {
      nativeLibs = [ pkgs.pango ];
    };
    cl-rabbit = pkg: {
      nativeBuildInputs = [ pkgs.rabbitmq-c ];
      nativeLibs = [ pkgs.rabbitmq-c ];
    };
    cl-rdkafka = pkg: {
      nativeBuildInputs = [ pkgs.rdkafka ];
      nativeLibs = [ pkgs.rdkafka ];
    };
    cl-readline = pkg: {
      nativeLibs = [ pkgs.readline ];
    };
    cl-rsvg2 = pkg: {
      nativeLibs = [ pkgs.librsvg ];
    };
    "cl-sat.glucose" = pkg: {
      propagatedBuildInputs = [ pkgs.glucose ];
      patches = [ ./patches/cl-sat.glucose-binary-from-PATH-if-present.patch ];

    };
    "cl-sat.minisat" = pkg: {
      propagatedBuildInputs = [ pkgs.minisat ];
    };
    cl-webkit2 = pkg: {
      nativeLibs = [ pkgs.webkitgtk ];
    };
    classimp = pkg: {
      nativeLibs = [ pkgs.assimp ];
      meta.broken = true; # Requires assimp ≤ 5.0.x.
    };
    clsql-postgresql = pkg: {
      nativeLibs = [ pkgs.postgresql.lib ];
    };
    clsql-sqlite3 = pkg: {
      nativeLibs = [ pkgs.sqlite ];
    };
    dbd-mysql = pkg: {
      nativeLibs = [ pkgs.mariadb.client ];
    };
    gsll = pkg: {
      nativeBuildInputs = [ pkgs.gsl ];
      nativeLibs = [ pkgs.gsl ];
    };
    iolib = pkg: {
      nativeBuildInputs = [ pkgs.libfixposix ];
      nativeLibs = [ pkgs.libfixposix ];
      systems = [ "iolib" "iolib/os" "iolib/pathnames" ];
    };
    lev = pkg: {
      nativeLibs = [ pkgs.libev ];
    };
    lispbuilder-sdl-cffi = pkg: {
      nativeLibs = [ pkgs.SDL ];
    };
    lla = pkg: {
      nativeLibs = [ pkgs.openblas ];
    };
    mssql = pkg: {
      nativeLibs = [ pkgs.freetds ];
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
      nativeLibs = [ pkgs.SDL2 ];
    };
    sqlite = pkg: {
      nativeLibs = [ pkgs.sqlite ];
    };
    trivial-package-manager = pkg: {
      propagatedBuildInputs = [ pkgs.which ];
    };
    trivial-ssh-libssh2 = pkg: {
      nativeLibs = [ pkgs.libssh2 ];
    };
    zmq = pkg: {
      nativeBuildInputs = [ pkgs.zeromq ];
      nativeLibs = [ pkgs.zeromq ];
    };
  };

  qlpkgs =
    lib.optionalAttrs (builtins.pathExists ./imported.nix)
      (import ./imported.nix { inherit (pkgs) runCommand fetchzip; pkgs = builtQlpkgs; });

  builtQlpkgs = lib.mapAttrs (n: v: build v) qlpkgs;

  build = pkg:
    let
      builtPkg = build-asdf-system pkg;
      withExtras = pkg //
                   (lib.optionalAttrs
                     (lib.hasAttr pkg.pname extras)
                     (extras.${pkg.pname} builtPkg));
      fixedUp = fixup withExtras;
    in build-asdf-system fixedUp;

in builtQlpkgs
