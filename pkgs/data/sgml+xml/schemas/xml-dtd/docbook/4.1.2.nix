{stdenv, fetchurl, unzip, findXMLCatalogs}:

let

  # Urgh, DocBook 4.1.2 doesn't come with an XML catalog.  Use the one
  # from 4.2.
  docbook42catalog = fetchurl {
    url = http://www.docbook.org/xml/4.2/catalog.xml;
    sha256 = "18lhp6q2l0753s855r638shkbdwq9blm6akdjsc9nrik24k38j17";
  };

in

import ./generic.nix {
  inherit stdenv fetchurl unzip findXMLCatalogs;
  name = "docbook-xml-4.1.2";
  src = fetchurl {
    url = http://www.docbook.org/xml/4.1.2/docbkx412.zip;
    sha256 = "0wkp5rvnqj0ghxia0558mnn4c7s3n501j99q2isp3sp0ci069w1h";
  };
  postInstall = "
    sed 's|V4.2|V4.1.2|g' < ${docbook42catalog} > catalog.xml
  ";
  meta = {
    branch = "4.1.2";
  };
}
