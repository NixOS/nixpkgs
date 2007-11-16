args: with args;
# !!! xml2po needs to store the path to libxml2

stdenv.mkDerivation {
  inherit (input) name src;
  
  buildInputs = [
    pkgconfig perl perlXMLParser python
    libxml2 libxslt gettext python libxml2Python
  ];

  configureFlags = "--disable-scrollkeeper";

  postInstall = "
    mv \$out/bin/xml2po \$out/bin/.xml2po.orig
    pythonPathLibXml2=\"\$(toPythonPath ${libxml2Python})\"
    echo -e '#! ${stdenv.shell}\nPYTHONPATH=$PYTHONPATH:'\"\$( toPythonPath \$out  )"+
    ":\${pythonPathLibXml2//python2.5/python2.4}"+
    ":\$( toPythonPath ${libxml2Python} )\""+
    "' \$(dirname \$0)/.xml2po.orig \"\$@\"' > \$out/bin/xml2po;
    chmod a+x \$out/bin/xml2po
  ";
}
