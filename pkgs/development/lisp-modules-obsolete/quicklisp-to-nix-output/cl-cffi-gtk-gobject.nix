/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-cffi-gtk-gobject";
  version = "cl-cffi-gtk-20201220-git";

  description = "A Lisp binding GObject 2";

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."cl-cffi-gtk-glib" args."closer-mop" args."iterate" args."trivial-features" args."trivial-garbage" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-cffi-gtk/2020-12-20/cl-cffi-gtk-20201220-git.tgz";
    sha256 = "15vc0d7nirh0m6rkvzby2zb7qcpyvsxzs5yw5h6h3madyl8qm9b1";
  };

  packageName = "cl-cffi-gtk-gobject";

  asdFilesToKeep = ["cl-cffi-gtk-gobject.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-cffi-gtk-gobject DESCRIPTION A Lisp binding GObject 2 SHA256
    15vc0d7nirh0m6rkvzby2zb7qcpyvsxzs5yw5h6h3madyl8qm9b1 URL
    http://beta.quicklisp.org/archive/cl-cffi-gtk/2020-12-20/cl-cffi-gtk-20201220-git.tgz
    MD5 954beac0970a46263153c2863ad1cb5f NAME cl-cffi-gtk-gobject FILENAME
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
    VERSION cl-cffi-gtk-20201220-git SIBLINGS
    (cl-cffi-gtk-cairo cl-cffi-gtk-demo-cairo cl-cffi-gtk-demo-glib
     cl-cffi-gtk-demo-gobject cl-cffi-gtk-example-gtk cl-cffi-gtk-opengl-demo
     cl-cffi-gtk-gdk-pixbuf cl-cffi-gtk-gdk cl-cffi-gtk-gio cl-cffi-gtk-glib
     cl-cffi-gtk cl-cffi-gtk-pango)
    PARASITES NIL) */
