# XCB_UTIL_COMMON(xcb-required-version, xcb-proto-required-version)
# -----------------------------------------------------------------
#
# Defines default options for xcb-util libraries.  xorg/util/macros >=
# 1.6.0 is  required for  cross-platform compiler  flags and  to build
# library documentation.
#
AC_DEFUN([XCB_UTIL_COMMON], [
m4_ifndef([AX_COMPARE_VERSION],
          [m4_fatal([could not find AX_COMPARE_VERSION in macros search path])])

AC_REQUIRE([AC_PROG_LIBTOOL])

# Define header files and pkgconfig paths
xcbincludedir='${includedir}/xcb'
AC_SUBST(xcbincludedir)
pkgconfigdir='${libdir}/pkgconfig'
AC_SUBST(pkgconfigdir)

# Check xcb version
PKG_CHECK_MODULES(XCB, xcb >= [$1])

# Check version of xcb-proto that xcb was compiled against
xcbproto_required=[$2]

AC_MSG_CHECKING([whether libxcb was compiled against xcb-proto >= $xcbproto_required])
xcbproto_version=`$PKG_CONFIG --variable=xcbproto_version xcb`
AX_COMPARE_VERSION([$xcbproto_version],[ge],[$xcbproto_required], xcbproto_ok="yes",
                   xcbproto_ok="no")
AC_MSG_RESULT([$xcbproto_ok])

if test $xcbproto_ok = no; then
   AC_MSG_ERROR([libxcb was compiled against xcb-proto $xcbproto_version; it needs to be compiled against version $xcbproto_required or higher])
fi

# Call macros from Xorg util-macros
m4_ifndef([XORG_MACROS_VERSION],
          [m4_fatal([must install xorg-macros 1.6.0 or later before running autoconf/autogen])])

XORG_MACROS_VERSION([1.6.0])
XORG_DEFAULT_OPTIONS
XORG_ENABLE_DEVEL_DOCS
XORG_WITH_DOXYGEN
]) # XCB_UTIL_COMMON
