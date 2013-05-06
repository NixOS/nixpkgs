{ kde, kdelibs, kde_baseapps }:

kde {

  # Needs kdebase for libkonq
  buildInputs = [ kdelibs kde_baseapps ];

  patchPhase = ''
    sed -i 's@macro_optional_add_subdirectory(git)@add_subdirectory(git)@' dolphin-plugins/CMakeLists.txt
  '';

  meta = {
    description = "Git plugin for dolphin";
  };
}
