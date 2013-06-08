{ kde, kdelibs, kde_baseapps }:

kde {

  # Needs kdebase for libkonq
  buildInputs = [ kdelibs kde_baseapps ];

  patchPhase = ''
    sed -i 's@macro_optional_add_subdirectory(hg)@add_subdirectory(hg)@' dolphin-plugins/CMakeLists.txt
  '';

  meta = {
    description = "Mercurial plugin for dolphin";
  };
}
