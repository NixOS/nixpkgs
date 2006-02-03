{stdenv, fetchurl, toolbuslib, atermjava, aterm, yacc, flex} :

stdenv.mkDerivation {
   name = "toolbus-1.2.2";
   src = fetchurl {
            url = http://www.cwi.nl/projects/MetaEnv/toolbus/toolbus-1.2.2.tar.gz;
            md5 = "887349b097006c0883e1948797349a50";
         };
   inherit toolbuslib atermjava aterm yacc flex;
   buildInputs = [toolbuslib atermjava aterm yacc flex];
}
