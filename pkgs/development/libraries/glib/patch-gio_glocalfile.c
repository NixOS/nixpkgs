$NetBSD: patch-gio_glocalfile.c,v 1.1 2013/04/19 22:21:41 prlw1 Exp $

In is_remote_fs(), statfs_result is also used in the USE_STATVFS
case.
    
https://bugzilla.gnome.org/show_bug.cgi?id=698348

--- glib-2.36.4/gio/glocalfile.c.orig	2013-03-25 17:02:43.000000000 +0000
+++ glib-2.36.4/gio/glocalfile.c
@@ -2422,10 +2422,10 @@ static gboolean
 is_remote_fs (const gchar *filename)
 {
   const char *fsname = NULL;
+  int statfs_result = 0;
 
 #ifdef USE_STATFS
   struct statfs statfs_buffer;
-  int statfs_result = 0;
 
 #if STATFS_ARGS == 2
   statfs_result = statfs (filename, &statfs_buffer);
