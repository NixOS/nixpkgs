{ pkgs, lib, build-asdf-system, ... }:

let

  # FIXME: automatically add nativeLibs based on conditions signalled

  overrides = (self: super: {
    cl_plus_ssl = super.cl_plus_ssl.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.openssl ];
    });
    cl-cffi-gtk-glib = super.cl-cffi-gtk-glib.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.glib ];
    });
    cl-cffi-gtk-cairo = super.cl-cffi-gtk-cairo.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.cairo ];
    });
    cl-cairo2 = super.cl-cairo2.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.cairo ];
    });
    cl-cairo2-xlib = super.cl-cairo2-xlib.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.gtk2-x11 ];
    });
    cl-freeimage = super.cl-freeimage.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.freeimage ];
    });
    cl-freetype2 = super.cl-freetype2.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.freetype ];
      nativeBuildInputs = [ pkgs.freetype ];
      patches = [ ./patches/cl-freetype2-fix-grovel-includes.patch ];
    });
    cl-pango = super.cl-pango.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.pango ];
    });
    cl-gtk2-gdk = super.cl-gtk2-gdk.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.gtk2-x11 ];
    });
    cl-gtk2-glib = super.cl-gtk2-glib.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.glib ];
    });
    cl-gtk2-pango = super.cl-gtk2-pango.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.pango ];
    });
    cl-rsvg2 = super.cl-rsvg2.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.librsvg ];
    });
    cl-cffi-gtk-gdk = super.cl-cffi-gtk-gdk.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.gtk3 ];
    });
    cl-cffi-gtk-gdk-pixbuf = super.cl-cffi-gtk-gdk-pixbuf.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.gdk-pixbuf ];
    });
    cl-cffi-gtk-pango = super.cl-cffi-gtk-pango.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.pango ];
    });
    cl-gobject-introspection = super.cl-gobject-introspection.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.glib pkgs.gobject-introspection ];
    });
    cl-mysql = super.cl-mysql.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.mariadb.client ];
    });
    clsql-postgresql = super.clsql-postgresql.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.postgresql.lib ];
    });
    clsql-sqlite3 = super.clsql-sqlite3.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.sqlite ];
    });
    cl-webkit2 = super.cl-webkit2.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.webkitgtk ];
    });
    dbd-mysql = super.dbd-mysql.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.mariadb.client ];
    });
    lla = super.lla.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.openblas ];
    });
    cffi-libffi = super.cffi-libffi.overrideLispAttrs (o: {
      nativeBuildInputs = [ pkgs.libffi ];
      nativeLibs = [ pkgs.libffi ];
    });
    cl-rabbit = super.cl-rabbit.overrideLispAttrs (o: {
      nativeBuildInputs = [ pkgs.rabbitmq-c ];
      nativeLibs = [ pkgs.rabbitmq-c ];
    });
    trivial-ssh-libssh2 = super.trivial-ssh-libssh2.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.libssh2 ];
    });
    sqlite = super.sqlite.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.sqlite ];
    });
    cl-libuv = super.cl-libuv.overrideLispAttrs (o: {
      nativeBuildInputs = [ pkgs.libuv ];
      nativeLibs = [ pkgs.libuv ];
    });
    cl-liballegro = super.cl-liballegro.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.allegro5 ];
    });
    cl-ode = super.cl-ode.overrideLispAttrs (o: {
      nativeLibs = let
        ode' = pkgs.ode.overrideAttrs (o: {
          configureFlags = [
            "--enable-shared"
            "--enable-double-precision"
          ];
        });
      in [ ode' ];
    });
    classimp = super.classimp.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.assimp ];
    });
    sdl2 = super.sdl2.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.SDL2 ];
    });
    lispbuilder-sdl-cffi = super.lispbuilder-sdl-cffi.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.SDL ];
    });
    cl-opengl = super.cl-opengl.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.libGL ];
    });
    cl-glu = super.cl-glu.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.libGLU ];
    });
    cl-glut = super.cl-glut.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.freeglut ];
    });
    cl-glfw = super.cl-glfw.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.glfw ];
    });
    cl-glfw-opengl-core = super.cl-glfw-opengl-core.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.libGL ];
    });
    cl-glfw3 = super.cl-glfw3.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.glfw ];
    });
    lev = super.lev.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.libev ];
    });
    cl-rdkafka = super.cl-rdkafka.overrideLispAttrs (o: {
      nativeBuildInputs = [ pkgs.rdkafka ];
      nativeLibs = [ pkgs.rdkafka ];
    });
    cl-async-ssl = super.cl-async-ssl.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.openssl ];
    });
    iolib = super.iolib.overrideLispAttrs (o: {
      nativeBuildInputs = [ pkgs.libfixposix ];
      nativeLibs = [ pkgs.libfixposix ];
      systems = [ "iolib" "iolib/os" "iolib/pathnames" ];
    });
    cl-ana_dot_hdf-cffi = super.cl-ana_dot_hdf-cffi.overrideLispAttrs (o: {
      nativeBuildInputs = [ pkgs.hdf5 ];
      nativeLibs = [ pkgs.hdf5 ];
      NIX_LDFLAGS = [ "-lhdf5" ];
    });
    gsll = super.gsll.overrideLispAttrs (o: {
      nativeBuildInputs = [ pkgs.gsl ];
      nativeLibs = [ pkgs.gsl ];
    });
    cl-libyaml = super.cl-libyaml.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.libyaml ];
    });
    cl-libxml2 = super.cl-libxml2.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.libxml2 ];
    });
    cl-readline = super.cl-readline.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.readline ];
    });
    log4cl = super.log4cl.overrideLispAttrs (o: {
      patches = [ ./patches/log4cl-fix-build.patch ];
    });
    md5 = super.md5.overrideLispAttrs (o: {
      lispLibs = [ super.flexi-streams ];
    });
    pzmq = super.pzmq.overrideLispAttrs (o: {
      nativeBuildInputs = [ pkgs.zeromq ];
      nativeLibs = [ pkgs.zeromq ];
    });
    pzmq-compat = super.pzmq-compat.overrideLispAttrs (o: {
      nativeBuildInputs = [ pkgs.zeromq ];
      nativeLibs = [ pkgs.zeromq ];
    });
    pzmq-examples = super.pzmq-examples.overrideLispAttrs (o: {
      nativeBuildInputs = [ pkgs.zeromq ];
      nativeLibs = [ pkgs.zeromq ];
    });
    pzmq-test = super.pzmq-test.overrideLispAttrs (o: {
      nativeBuildInputs = [ pkgs.zeromq ];
      nativeLibs = [ pkgs.zeromq ];
    });
    cl-git = super.cl-git.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.libgit2 ];
    });
    trivial-package-manager = super.trivial-package-manager.overrideLispAttrs (o: {
      propagatedBuildInputs = [ pkgs.which ];
    });
    cl-sat_dot_glucose = super.cl-sat_dot_glucose.overrideLispAttrs (o: {
      propagatedBuildInputs = [ pkgs.glucose ];
      patches = [ ./patches/cl-sat-binary-from-path.patch ];
    });
    cl-sat_dot_minisat = super.cl-sat_dot_minisat.overrideLispAttrs (o: {
      propagatedBuildInputs = [ pkgs.minisat ];
    });
    hu_dot_dwim_dot_graphviz = super.hu_dot_dwim_dot_graphviz.overrideLispAttrs (o: {
      nativeLibs = [ pkgs.graphviz ];
    });
    math = super.math.overrideLispAttrs (o: {
      patches = [ ./patches/math-no-compile-time-directory.patch ];
      nativeLibs = [ pkgs.fontconfig ];
    });
    mcclim-fonts = super.mcclim-fonts.overrideLispAttrs (o: {
      lispLibs = o.lispLibs ++ [
        super.cl-dejavu
        super.zpb-ttf
        super.cl-vectors
        super.cl-paths-ttf
        super.flexi-streams
      ];
      systems = [ "mcclim-fonts" "mcclim-fonts/truetype" ];
    });
    mcclim-render = super.mcclim-render.overrideLispAttrs (o: {
      lispLibs = o.lispLibs ++ [
        self.mcclim-fonts
      ];
    });
    mcclim-layouts = super.mcclim-layouts.overrideLispAttrs (o: {
      systems = [ "mcclim-layouts" "mcclim-layouts/tab" ];
      lispLibs = o.lispLibs ++ [
        self.mcclim
      ];
});
  });

  qlpkgs =
    lib.optionalAttrs (builtins.pathExists ./imported.nix)
      (pkgs.callPackage ./imported.nix { inherit build-asdf-system; });

in qlpkgs.overrideScope' overrides
