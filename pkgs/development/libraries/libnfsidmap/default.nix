{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libnfsidmap-0.25";
  
  src = fetchurl {
    url = "http://www.citi.umich.edu/projects/nfsv4/linux/libnfsidmap/${name}.tar.gz";
    sha256 = "1kzgwxzh83qi97rblcm9qj80cdvnv8kml2plz0q103j0hifj8vb5";
  };

  meta = {
    homepage = http://www.citi.umich.edu/projects/nfsv4/linux/;
    description = "Library for holding mulitiple methods of mapping names to id's and visa versa, mainly for NFSv4";
    license = "BSD";
  };
}
