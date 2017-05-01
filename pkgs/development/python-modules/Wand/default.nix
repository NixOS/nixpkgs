{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, imagemagick
, pytest
, psutil
, memory_profiler
, pytest_xdist
, sharedLibraryExtension
}:

let
  magick_wand_library = "${imagemagick}/lib/libMagickWand-6.Q16${sharedLibraryExtension}";
  imagemagick_library = "${imagemagick}/lib/libMagickCore-6.Q16${sharedLibraryExtension}";
in buildPythonPackage rec {
  pname = "Wand";
  version = "0.4.4";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "28e0454c9d16d69c5d5034918d96320d8f9f1377b4fdaf4944eec2f938c74704";
  };

  checkInputs = [ pytest pytest_xdist memory_profiler psutil ];

  buildInputs = [ imagemagick ];

  patches = [
    ./libraries.patch
  ];

  inherit magick_wand_library imagemagick_library;

  postPatch = ''
    substituteAllInPlace wand/api.py
  '';

  # No tests
  doCheck = false;
  meta = {
    description = "Ctypes-based simple MagickWand API binding for Python";
    homepage = http://wand-py.org/;
    license = with lib.licenses; [ mit ];
  };

  passthru = {
    inherit imagemagick;
  };
}
