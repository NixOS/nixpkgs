{ kde, kdelibs, kde_baseapps }:

kde {
  # Needs kdebase for libkonq
  buildInputs = [ kdelibs kde_baseapps ];

  meta = {
    description = "Svn plugin for dolphin";
  };
}
