{ lib
, buildPythonPackage
, fetchurl
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "memcached";
  version = "1.51";

  src = if isPy3k then fetchPypi {
    inherit version;
    pname = "python3-${pname}";
    sha256 = "0na8b369q8fivh3y0nvzbvhh3lgvxiyyv9xp93cnkvwfsr8mkgkw";
  } else fetchurl {
    url = "http://ftp.tummy.com/pub/python-memcached/old-releases/python-${pname}-${version}.tar.gz";
    sha256 = "124s98m6hvxj6x90d7aynsjfz878zli771q96ns767r2mbqn7192";
  };

  meta = with lib; {
    description = "Python API for communicating with the memcached distributed memory object cache daemon";
    homepage = "http://www.tummy.com/Community/software/python-memcached/";
    license = licenses.psfl;
  };

}
