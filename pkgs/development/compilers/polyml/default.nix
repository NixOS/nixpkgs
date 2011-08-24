{stdenv, fetchurl}:

let
  pname = "polyml";
  version = "5.4";
in

stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}.${version}.tar.gz";
    sha256 = "1ykbm4zk260dkdr8jl7mjaqxy98h65fq0z82k44b1fp5q8zy5d34";
  };

  meta = {
    description = "Standard ML compiler and interpreter";
    longDescription = ''
      Poly/ML is a full implementation of Standard ML.
    '';
    homepage = http://www.polyml.org/;
    license = "LGPL";
    platforms = with stdenv.lib.platforms; linux;
    maintainers = [ #Add your name here!
      stdenv.lib.maintainers.z77z
    ];
  };
}
