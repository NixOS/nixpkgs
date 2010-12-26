#Macro to find xscreensaver directory

# Copyright (c) 2006, Laurent Montel, <montel@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

if (NOT XSCREENSAVER_FOUND)
  FIND_PATH(XSCREENSAVER_DIR deco
    HINTS
      ${KDE4_INCLUDE_DIR}
    PATHS
      /usr
      /usr/local
      /opt/local
      /usr/X11R6
      /opt/kde
      /opt/kde3
      /usr/kde
      /usr/local/kde
      /usr/local/xscreensaver
      /usr/openwin/lib/xscreensaver
      /etc
    PATH_SUFFIXES
      lib${LIB_SUFFIX}/xscreensaver
      lib${LIB_SUFFIX}/misc/xscreensaver
      lib/xscreensaver
      lib64/xscreensaver
      lib/misc/xscreensaver
      libexec/xscreensaver
      bin/xscreensaver-hacks
      hacks)
  message(STATUS "XSCREENSAVER_DIR <${XSCREENSAVER_DIR}>")

  FIND_PATH(XSCREENSAVER_CONFIG_DIR deco.xml
    PATHS
    ${KDE4_INCLUDE_DIR}
    /usr/
    /usr/local/
    /opt/local/
    /usr/X11R6/
    /opt/kde/
    /opt/kde3/
    /usr/kde/
    /usr/local/kde/
    /usr/openwin/lib/xscreensaver/
    /etc/
    PATH_SUFFIXES xscreensaver xscreensaver/config share/xscreensaver/config
  )
  MESSAGE(STATUS "XSCREENSAVER_CONFIG_DIR :<${XSCREENSAVER_CONFIG_DIR}>")

endif(NOT XSCREENSAVER_FOUND)

#MESSAGE(STATUS "XSCREENSAVER_CONFIG_DIR :<${XSCREENSAVER_CONFIG_DIR}>")
#MESSAGE(STATUS "XSCREENSAVER_DIR :<${XSCREENSAVER_DIR}>")

# Need to fix hack
if(XSCREENSAVER_DIR AND XSCREENSAVER_CONFIG_DIR)
    set(XSCREENSAVER_FOUND TRUE)
endif(XSCREENSAVER_DIR AND XSCREENSAVER_CONFIG_DIR)

if (XSCREENSAVER_FOUND)
  if (NOT Xscreensaver_FIND_QUIETLY)
    message(STATUS "Found XSCREENSAVER_CONFIG_DIR <${XSCREENSAVER_CONFIG_DIR}>")
  endif (NOT Xscreensaver_FIND_QUIETLY)
else (XSCREENSAVER_FOUND)
  if (Xscreensaver_FIND_REQUIRED)
    message(FATAL_ERROR "XScreenSaver not found")
  endif (Xscreensaver_FIND_REQUIRED)
endif (XSCREENSAVER_FOUND)


MARK_AS_ADVANCED(XSCREENSAVER_DIR XSCREENSAVER_CONFIG_DIR)
