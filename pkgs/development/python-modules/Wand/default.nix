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
  version = "0.4.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b40a2215545e8c7193b3fccd6e7251dc556ec9b878a4f67d992b056ff396bc65";
  };

  checkInputs = [ pytest pytest_xdist memory_profiler psutil ];

  buildInputs = [ imagemagick ];

  inherit magick_wand_library imagemagick_library;

  postPatch = ''
    substituteAllInPlace wand/api.py
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
