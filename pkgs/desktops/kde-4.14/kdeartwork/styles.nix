{ kde, kdelibs }:

kde rec {
  name = "kde-style-phase";

  buildInputs = [ kdelibs ];

  meta = {
    description = "Phase, a widget style for KDE";
  };
}
