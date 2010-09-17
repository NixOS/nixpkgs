{ kde, cmake, kdelibs, automoc4, libxml2, libxslt }:

kde.package {
  buildInputs = [ cmake kdelibs automoc4 libxml2 libxslt ];

  meta = {
    description = "An HTML imagemap editor";
    homepage = http://www.nongnu.org/kimagemap/;
    kde = {
      name = "kimagemapeditor";
      module = "kdewebdev";
      version = "3.9.0";
      release = "4.5.1";
    };
  };
}
