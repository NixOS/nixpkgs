{ lib
, buildPythonPackage
, fetchPypi
, pytest
, numpy
, libsndfile
, cffi
, isPyPy
, stdenv
}:

buildPythonPackage rec {
  pname = "PySoundFile";
  name = "PySoundFile-${version}";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "72c3e23b7c9998460ec78176084ea101e3439596ab29df476bc8508708df84df";
  };

    checkInputs = [ pytest ];
    propagatedBuildInputs = [ numpy libsndfile cffi ];

    meta = {
      description = "An audio library based on libsndfile, CFFI and NumPy";
      license = lib.licenses.bsd3;
      homepage = https://github.com/bastibe/PySoundFile;
      maintainers = with lib.maintainers; [ fridh ];
    };

    prePatch = ''
      substituteInPlace soundfile.py --replace "'sndfile'" "'${libsndfile.out}/lib/libsndfile.so'"
    '';

    # https://github.com/bastibe/PySoundFile/issues/157
    disabled = isPyPy ||  stdenv.isi686;
}