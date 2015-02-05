{ kde, kdelibs, gcc, libtool }:

kde {
  buildInputs = [ kdelibs libtool ];

  preConfigure = "export CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH:${gcc}:${gcc.cc}";

  meta = {
    description = "various KDE development utilities";
  };
}
