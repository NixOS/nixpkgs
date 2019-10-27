{ stdenv, zookeeper, bash }:

stdenv.mkDerivation rec {
  name = "zookeeper_mt-${stdenv.lib.getVersion zookeeper}";

  src = zookeeper.src;

  setSourceRoot = "export sourceRoot=${zookeeper.name}/src/c";

  NIX_CFLAGS_COMPILE = [ "-Wno-error=format-overflow" ];

  buildInputs = [ zookeeper bash ];

  meta = with stdenv.lib; {
    homepage = http://zookeeper.apache.org;
    description = "Apache Zookeeper";
    license = licenses.asl20;
    maintainers = [ maintainers.boothead ];
    platforms = platforms.unix;
  };
}
