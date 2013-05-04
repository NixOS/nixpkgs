{ kde, kdelibs, kde_baseapps }:

kde {
#todo: doesn't build
  # Needs kdebase for libkonq
  buildInputs = [ kdelibs kde_baseapps ];

  meta = {
    description = "Git plugin for dolphin";
  };
}
