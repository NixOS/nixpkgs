{ stdenv, fetchPypi, buildPythonPackage, fetchpatch }:

buildPythonPackage rec {
  pname = "faulthandler";
  version = "3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "acc10e10909f0f956ba1b42b6c450ea0bdaaa27b3942899f65931396cfcdd36a";
  };

  patches = [
    (fetchpatch {
      url = https://github.com/vstinner/faulthandler/commit/67b661e.patch;
      sha256 = "1nn8c9nq5qypja949hzz0n4yprsyr63wihf5g3gwrinm2nkjnnv7";
    })
    (fetchpatch {
      url = https://github.com/vstinner/faulthandler/commit/07cbb7b.patch;
      sha256 = "0fh6rjyjw7z1hsiy3sgdc8j9mncg1vlv3y0h4bplqyw18vq3srb3";
    })
  ];

  meta = {
    description = "Dump the Python traceback";
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [ sauyon ];
    homepage = http://faulthandler.readthedocs.io/;
  };
}
