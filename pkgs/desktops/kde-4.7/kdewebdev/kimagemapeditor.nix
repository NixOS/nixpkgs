{ kde, kdelibs, libxml2, libxslt }:

kde {
  buildInputs = [ kdelibs libxml2 libxslt ];

  meta = {
    description = "An HTML imagemap editor";
    homepage = http://www.nongnu.org/kimagemap/;
  };
}
