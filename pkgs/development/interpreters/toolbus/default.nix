{javaAdapter ? false,
 jdk ? null,
   stdenv, fetchurl, toolbuslib, atermjava, aterm, yacc, flex, tcltk} :

stdenv.mkDerivation {
   name = "toolbus-1.2.2";
   builder = ./builder.sh;
   src = fetchurl {
            url = http://nixos.org/tarballs/toolbus-1.2.2.tar.gz;
            md5 = "887349b097006c0883e1948797349a50";
         };
   java = if javaAdapter then true else false;
   jdk = if javaAdapter then jdk else null;

   inherit toolbuslib atermjava aterm yacc flex tcltk;
   buildInputs = [toolbuslib atermjava aterm yacc flex jdk tcltk] ;
}
