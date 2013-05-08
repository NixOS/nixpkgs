{ kde, kdelibs, kde_baseapps }:

kde {

  # Needs kdebase for libkonq
  buildInputs = [ kdelibs kde_baseapps ];

  patchPhase = ''
    sed -i 's@macro_optional_add_subdirectory(svn)@add_subdirectory(svn)@' dolphin-plugins/CMakeLists.txt
  '';

  meta = {
    description = "Svn plugin for dolphin";
  };
}
