{ kde, kdelibs }:

kde {
  buildInputs = [ kdelibs ];

  meta = {
    description = "An HTML imagemap editor";
    homepage = http://www.nongnu.org/kimagemap/;
  };
}
