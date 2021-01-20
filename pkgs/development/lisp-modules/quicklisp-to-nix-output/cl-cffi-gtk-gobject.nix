args @ { fetchurl, ... }:
rec {
  baseName = ''cl-cffi-gtk-gobject'';
  version = ''cl-cffi-gtk-20201016-git'';

  description = ''A Lisp binding GObject 2'';

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."cl-cffi-gtk-glib" args."closer-mop" args."iterate" args."trivial-features" args."trivial-garbage" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-cffi-gtk/2020-10-16/cl-cffi-gtk-20201016-git.tgz'';
    sha256 = ''1m91597nwwrps32awvk57k3h4jjq603ja0kf395n2jxvckfz0a55'';
  };

  packageName = "cl-cffi-gtk-gobject";

  asdFilesToKeep = ["cl-cffi-gtk-gobject.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-cffi-gtk-gobject DESCRIPTION A Lisp binding GObject 2 SHA256
    1m91597nwwrps32awvk57k3h4jjq603ja0kf395n2jxvckfz0a55 URL
    http://beta.quicklisp.org/archive/cl-cffi-gtk/2020-10-16/cl-cffi-gtk-20201016-git.tgz
    MD5 7eef130d69af506c68b2d98271215fbd NAME cl-cffi-gtk-gobject FILENAME
    cl-cffi-gtk-gobject DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cffi FILENAME cffi)
     (NAME cl-cffi-gtk-glib FILENAME cl-cffi-gtk-glib)
     (NAME closer-mop FILENAME closer-mop) (NAME iterate FILENAME iterate)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-garbage FILENAME trivial-garbage))
    DEPENDENCIES
    (alexandria babel bordeaux-threads cffi cl-cffi-gtk-glib closer-mop iterate
     trivial-features trivial-garbage)
    VERSION cl-cffi-gtk-20201016-git SIBLINGS
    (cl-cffi-gtk-cairo cl-cffi-gtk-demo-cairo cl-cffi-gtk-demo-glib
     cl-cffi-gtk-demo-gobject cl-cffi-gtk-example-gtk cl-cffi-gtk-opengl-demo
     cl-cffi-gtk-gdk-pixbuf cl-cffi-gtk-gdk cl-cffi-gtk-gio cl-cffi-gtk-glib
     cl-cffi-gtk cl-cffi-gtk-pango)
    PARASITES NIL) */
