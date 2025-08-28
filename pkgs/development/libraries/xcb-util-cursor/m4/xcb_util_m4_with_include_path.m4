# XCB_UTIL_M4_WITH_INCLUDE_PATH
# ------------------------------
#
# This macro attempts to locate an m4 macro processor which supports
# -I option and is only useful for modules relying on M4 in order to
# expand macros in source code files.
#
# M4: variable holding the path to an usable m4 program.
#
# This macro  requires Autoconf 2.62  or later  as it is  relying upon
# AC_PATH_PROGS_FEATURE_CHECK  macro. NOTE:  As  soon  as the  minimum
# required version of Autoconf for Xorg  is bumped to 2.62, this macro
# is supposed to be shipped with xorg/util/macros.
#
AC_DEFUN([XCB_UTIL_M4_WITH_INCLUDE_PATH], [
AC_CACHE_CHECK([for m4 that supports -I option], [ac_cv_path_M4],
   [AC_PATH_PROGS_FEATURE_CHECK([M4], [m4 gm4],
       [[$ac_path_M4 -I. /dev/null > /dev/null 2>&1 && \
         ac_cv_path_M4=$ac_path_M4 ac_path_M4_found=:]],
   [AC_MSG_ERROR([could not find m4 that supports -I option])],
   [$PATH:/usr/gnu/bin])])

AC_SUBST([M4], [$ac_cv_path_M4])
]) # XCB_UTIL_M4_WITH_INCLUDE_PATH
