/*
 * gtkD is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License
 * as published by the Free Software Foundation; either version 3
 * of the License, or (at your option) any later version, with
 * some exceptions, please read the COPYING file.
 *
 * gtkD is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with gtkD; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110, USA
 *
 * paths.d  -- list of libraries that will be dynamically linked with gtkD
 *
 * Added:	John Reimer	-- 2004-12-20
 * Updated: 2005-02-21 changed names; added version(linux)
 * Updated: 2005-05-05 updated Linux support
 * Updated: 2008-02-16 Tango support
 */

module gtkd.paths;

/*
 * Define the Libraries that gtkD will be using.
 *   This is a growable list, as long as the programmer
 *   also adds to the importLibs list.
 */

enum LIBRARY
{
	ATK,
	CAIRO,
	GDK,
	GDKPIXBUF,
	GLIB,
	GMODULE,
	GOBJECT,
	GIO,
	GTHREAD,
	GTK,
	PANGO,
	PANGOCAIRO,
	GLGDK,
	GLGTK,
	GDA,
	GSV,
	GSV1,
	GSTREAMER,
	GSTINTERFACES,
	VTE,
	PEAS,
	RSVG,
}

version (Windows)
{
	const string[LIBRARY.max+1] importLibs =
	[
		LIBRARY.ATK:           "libatk-1.0-0.dll",
		LIBRARY.CAIRO:         "libcairo-2.dll",
		LIBRARY.GDK:           "libgdk-3-0.dll",
		LIBRARY.GDKPIXBUF:     "libgdk_pixbuf-2.0-0.dll",
		LIBRARY.GLIB:          "libglib-2.0-0.dll",
		LIBRARY.GMODULE:       "libgmodule-2.0-0.dll",
		LIBRARY.GOBJECT:       "libgobject-2.0-0.dll",
		LIBRARY.GIO:           "libgio-2.0-0.dll",
		LIBRARY.GTHREAD:       "libgthread-2.0-0.dll",
		LIBRARY.GTK:           "libgtk-3-0.dll",
		LIBRARY.PANGO:         "libpango-1.0-0.dll",
		LIBRARY.PANGOCAIRO:    "libpangocairo-1.0-0.dll",
		LIBRARY.GLGDK:         "libgdkglext-3.0-0.dll",
		LIBRARY.GLGTK:         "libgtkglext-3.0-0.dll",
		LIBRARY.GDA:           "libgda-4.0-4.dll",
		LIBRARY.GSV:           "libgtksourceview-3.0-0.dll",
		LIBRARY.GSV1:          "libgtksourceview-3.0-1.dll",
		LIBRARY.GSTREAMER:     "libgstreamer-1.0.dll",
		LIBRARY.GSTINTERFACES: "libgstvideo-1.0.dll",
		LIBRARY.VTE:           "libvte-2.91.dll",
		LIBRARY.PEAS:          "libpeas-1.0.dll",
		LIBRARY.RSVG:          "librsvg-2-2.dll",
	];
}
else version(darwin)
{
	const string[LIBRARY.max+1] importLibs =
	[
		LIBRARY.ATK:           "@atk@/lib/libatk-1.0.dylib",
		LIBRARY.CAIRO:         "@cairo@/lib/libcairo.dylib",
		LIBRARY.GDK:           "@gtk3@/lib/libgdk-3.0.dylib",
		LIBRARY.GDKPIXBUF:     "@gdk_pixbuf@/lib/libgdk_pixbuf-2.0.dylib",
		LIBRARY.GLIB:          "@glib@/lib/libglib-2.0.dylib",
		LIBRARY.GMODULE:       "@glib@/lib/libgmodule-2.0.dylib",
		LIBRARY.GOBJECT:       "@glib@/lib/libgobject-2.0.dylib",
		LIBRARY.GIO:           "@glib@/lib/libgio-2.0.dylib",
		LIBRARY.GTHREAD:       "@glib@/lib/libgthread-2.0.dylib",
		LIBRARY.GTK:           "@gtk3@/lib/libgtk-3.0.dylib",
		LIBRARY.PANGO:         "@pango@/lib/libpango-1.0.dylib",
		LIBRARY.PANGOCAIRO:    "@pango@/lib/libpangocairo-1.0.dylib",
		LIBRARY.GLGDK:         "libgdkglext-3.0.dylib",
		LIBRARY.GLGTK:         "libgtkglext-3.0.dylib",
		LIBRARY.GDA:           "@libgda@/lib/libgda-2.dylib",
		LIBRARY.GSV:           "@gtksourceview@/lib/libgtksourceview-3.0.dylib",
		LIBRARY.GSV1:          "@gtksourceview@/lib/libgtksourceview-3.0.dylib",
		LIBRARY.GSTREAMER:     "@gstreamer@/lib/libgstreamer-1.0.dylib",
		LIBRARY.GSTINTERFACES: "@gst_plugins_base@/lib/libgstvideo-1.0.dylib",
		LIBRARY.VTE:           "@vte@/lib/libvte-2.91.dylib",
		LIBRARY.PEAS:          "@libpeas@/lib/libpeas-1.0.dylib",
		LIBRARY.RSVG:          "@librsvg@/lib/librsvg-2.dylib",
	];
}
else
{
	const string[LIBRARY.max+1] importLibs =
	[
		LIBRARY.ATK:           "@atk@/lib/libatk-1.0.so.0",
		LIBRARY.CAIRO:         "@cairo@/lib/libcairo.so.2",
		LIBRARY.GDK:           "@gtk3@/lib/libgdk-3.so.0",
		LIBRARY.GDKPIXBUF:     "@gdk_pixbuf@/lib/libgdk_pixbuf-2.0.so.0",
		LIBRARY.GLIB:          "@glib@/lib/libglib-2.0.so.0",
		LIBRARY.GMODULE:       "@glib@/lib/libgmodule-2.0.so.0",
		LIBRARY.GOBJECT:       "@glib@/lib/libgobject-2.0.so.0",
		LIBRARY.GIO:           "@glib@/lib/libgio-2.0.so.0",
		LIBRARY.GTHREAD:       "@glib@/lib/libgthread-2.0.so.0",
		LIBRARY.GTK:           "@gtk3@/lib/libgtk-3.so.0",
		LIBRARY.PANGO:         "@pango@/lib/libpango-1.0.so.0",
		LIBRARY.PANGOCAIRO:    "@pango@/lib/libpangocairo-1.0.so.0",
		LIBRARY.GLGDK:         "libgdkglext-3.0.so.0",
		LIBRARY.GLGTK:         "libgtkglext-3.0.so.0",
		LIBRARY.GDA:           "@libgda@/lib/libgda-4.0.so.4",
		LIBRARY.GSV:           "@gtksourceview@/lib/libgtksourceview-3.0.so.0",
		LIBRARY.GSV1:          "@gtksourceview@/lib/libgtksourceview-3.0.so.1",
		LIBRARY.GSTREAMER:     "@gstreamer@/lib/libgstreamer-1.0.so.0",
		LIBRARY.GSTINTERFACES: "@gst_plugins_base@/lib/libgstvideo-1.0.so.0",
		LIBRARY.VTE:           "@vte@/lib/libvte-2.91.so.0",
		LIBRARY.PEAS:          "@libpeas@/lib/libpeas-1.0.so.0",
		LIBRARY.RSVG:          "@librsvg@/lib/librsvg-2.so.2",
	];
}
