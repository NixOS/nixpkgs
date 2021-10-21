/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-webkit2";
  version = "cl-webkit-20210807-git";

  description = "An FFI binding to WebKit2GTK+";

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."cl-cffi-gtk" args."cl-cffi-gtk-cairo" args."cl-cffi-gtk-gdk" args."cl-cffi-gtk-gdk-pixbuf" args."cl-cffi-gtk-gio" args."cl-cffi-gtk-glib" args."cl-cffi-gtk-gobject" args."cl-cffi-gtk-pango" args."closer-mop" args."iterate" args."trivial-features" args."trivial-garbage" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-webkit/2021-08-07/cl-webkit-20210807-git.tgz";
    sha256 = "12n2zjl8kpji5b24jj1jhnlw16ylkxw4czc1dynx3ligj17qf1an";
  };

  packageName = "cl-webkit2";

  asdFilesToKeep = ["cl-webkit2.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-webkit2 DESCRIPTION An FFI binding to WebKit2GTK+ SHA256
    12n2zjl8kpji5b24jj1jhnlw16ylkxw4czc1dynx3ligj17qf1an URL
    http://beta.quicklisp.org/archive/cl-webkit/2021-08-07/cl-webkit-20210807-git.tgz
    MD5 25b73593e97d7c075cb791a896e5b1d1 NAME cl-webkit2 FILENAME cl-webkit2
    DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cffi FILENAME cffi) (NAME cl-cffi-gtk FILENAME cl-cffi-gtk)
     (NAME cl-cffi-gtk-cairo FILENAME cl-cffi-gtk-cairo)
     (NAME cl-cffi-gtk-gdk FILENAME cl-cffi-gtk-gdk)
     (NAME cl-cffi-gtk-gdk-pixbuf FILENAME cl-cffi-gtk-gdk-pixbuf)
     (NAME cl-cffi-gtk-gio FILENAME cl-cffi-gtk-gio)
     (NAME cl-cffi-gtk-glib FILENAME cl-cffi-gtk-glib)
     (NAME cl-cffi-gtk-gobject FILENAME cl-cffi-gtk-gobject)
     (NAME cl-cffi-gtk-pango FILENAME cl-cffi-gtk-pango)
     (NAME closer-mop FILENAME closer-mop) (NAME iterate FILENAME iterate)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-garbage FILENAME trivial-garbage))
    DEPENDENCIES
    (alexandria babel bordeaux-threads cffi cl-cffi-gtk cl-cffi-gtk-cairo
     cl-cffi-gtk-gdk cl-cffi-gtk-gdk-pixbuf cl-cffi-gtk-gio cl-cffi-gtk-glib
     cl-cffi-gtk-gobject cl-cffi-gtk-pango closer-mop iterate trivial-features
     trivial-garbage)
    VERSION cl-webkit-20210807-git SIBLINGS NIL PARASITES NIL) */
