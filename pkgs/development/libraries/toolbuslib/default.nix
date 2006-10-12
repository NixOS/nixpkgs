{stdenv, fetchurl, aterm} :

stdenv.mkDerivation {
name = "toolbuslib-0.7.2";
src = fetchurl {
         url = http://nix.cs.uu.nl/dist/tarballs/toolbuslib-0.7.2.tar.gz;
         md5 = "6619a155c6326d728d53c6901558e350";
   };
inherit aterm;
buildinputs = [aterm];
}
