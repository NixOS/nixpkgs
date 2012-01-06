{ kde, kdelibs }:

kde {
  buildInputs = [ kdelibs ];

  meta = {
    description = "SVG KPart";
    license = "GPLv2";
  };
}
