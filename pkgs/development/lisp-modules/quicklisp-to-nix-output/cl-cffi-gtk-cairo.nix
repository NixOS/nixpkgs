args @ { fetchurl, ... }:
rec {
  baseName = ''cl-cffi-gtk-cairo'';
  version = ''cl-cffi-gtk-20201016-git'';

  description = ''A Lisp binding to Cairo'';

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."cl-cffi-gtk-glib" args."iterate" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-cffi-gtk/2020-10-16/cl-cffi-gtk-20201016-git.tgz'';
    sha256 = ''1m91597nwwrps32awvk57k3h4jjq603ja0kf395n2jxvckfz0a55'';
  };

  packageName = "cl-cffi-gtk-cairo";

  asdFilesToKeep = ["cl-cffi-gtk-cairo.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-cffi-gtk-cairo DESCRIPTION A Lisp binding to Cairo SHA256
    1m91597nwwrps32awvk57k3h4jjq603ja0kf395n2jxvckfz0a55 URL
    http://beta.quicklisp.org/archive/cl-cffi-gtk/2020-10-16/cl-cffi-gtk-20201016-git.tgz
    MD5 7eef130d69af506c68b2d98271215fbd NAME cl-cffi-gtk-cairo FILENAME
    cl-cffi-gtk-cairo DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cffi FILENAME cffi)
     (NAME cl-cffi-gtk-glib FILENAME cl-cffi-gtk-glib)
     (NAME iterate FILENAME iterate)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (alexandria babel bordeaux-threads cffi cl-cffi-gtk-glib iterate
     trivial-features)
    VERSION cl-cffi-gtk-20201016-git SIBLINGS
    (cl-cffi-gtk-demo-cairo cl-cffi-gtk-demo-glib cl-cffi-gtk-demo-gobject
     cl-cffi-gtk-example-gtk cl-cffi-gtk-opengl-demo cl-cffi-gtk-gdk-pixbuf
     cl-cffi-gtk-gdk cl-cffi-gtk-gio cl-cffi-gtk-glib cl-cffi-gtk-gobject
     cl-cffi-gtk cl-cffi-gtk-pango)
    PARASITES NIL) */
