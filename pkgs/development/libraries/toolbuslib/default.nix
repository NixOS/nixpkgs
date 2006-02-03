{stdenv, fetchurl, aterm} :

stdenv.mkDerivation {
name = "toolbuslib-0.7.2";
src = fetchurl {
         url = http://www.cwi.nl/projects/MetaEnv/toolbuslib/toolbuslib-0.7.2.tar.gz;
         md5 = "6619a155c6326d728d53c6901558e350";
   };
inherit aterm;
buildinputs = [aterm];
}
