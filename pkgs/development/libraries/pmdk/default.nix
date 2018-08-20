{ stdenv, fetchFromGitHub, pkgconfig, autoconf, automake, doxygen, graphviz, pandoc
}:

stdenv.mkDerivation rec {
       version = "1.4.1"; 
       name="pmdk-${version}";
       src = fetchFromGitHub {
           owner = "pmem";
           repo = "pmdk";
           rev = version;
           sha256 = "0ylif2ws1zz5dcfgidmm7nyhmvshclcas22gyx7zhyrkq2zs5npc";
       };

       nativeBuildInputs = [
          pkgconfig
          autoconf
          automake
          doxygen
          graphviz
          pandoc
       ];
       
       buildFlags = [ "EXTRA_CFLAGS=-Wno-error" ];

       preBuild = ''
            substituteInPlace Makefile --replace /usr /
            makeFlagsArray=(INSTALL=install prefix=$out)
           '';

       meta = {
            description = "Persistent memory programming";
            homepage = https://pmem.io/pmdk;
            license = licenses.bsd3;
            platforms = platforms.unix;
            maintainers = [ maintainers.barakb ];
	    };
}

