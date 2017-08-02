{ stdenv, zookeeper, bash }:

stdenv.mkDerivation rec {
   name = "zookeeper_mt";
   
   src = zookeeper.src;
   
   setSourceRoot = "export sourceRoot=${zookeeper.name}/src/c";

   buildInputs = [ zookeeper bash ];

   meta = with stdenv.lib; {
   	homepage = http://zookeeper.apache.org;
   	description = "Apache Zookeeper";
   	license = licenses.asl20;
   	maintainers = [ maintainers.boothead ];	
   	platforms = platforms.unix;	
   };
}

