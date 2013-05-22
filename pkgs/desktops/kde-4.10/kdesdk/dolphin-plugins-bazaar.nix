{ kde, kdelibs, kde_baseapps }:

kde {

  # Needs kdebase for libkonq
  buildInputs = [ kdelibs kde_baseapps ];

  patchPhase = ''
    sed -i 's@macro_optional_add_subdirectory(bazaar)@add_subdirectory(bazaar)@' dolphin-plugins/CMakeLists.txt
  '';

  meta = {
    description = "Bazaar plugin for dolphin";
  };
}
