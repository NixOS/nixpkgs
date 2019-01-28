{ stdenv
, buildPythonPackage
, fetchPypi
, imagemagick
, pytest
, psutil
, memory_profiler
, pytest_xdist
}:

let
  soext = stdenv.hostPlatform.extensions.sharedLibrary;
  magick_wand_library = "${imagemagick}/lib/libMagickWand-6.Q16${soext}";
  imagemagick_library = "${imagemagick}/lib/libMagickCore-6.Q16${soext}";
in buildPythonPackage rec {
  pname = "Wand";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rp1zdp2p7qngva5amcw4jb5i8gf569v8469gf6zj36hcnzksxjj";
  };

  checkInputs = [ pytest pytest_xdist memory_profiler psutil ];

  buildInputs = [ imagemagick ];

  inherit magick_wand_library imagemagick_library;

  postPatch = ''
    substituteInPlace wand/api.py --replace \
      "magick_home = os.environ.get('MAGICK_HOME')" \
      "magick_home = '${imagemagick}'"
  '';

  # tests not included with pypi release
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Ctypes-based simple MagickWand API binding for Python";
    homepage = http://wand-py.org/;
    license = [ licenses.mit ];
  };

  passthru = {
    inherit imagemagick;
  };
}
