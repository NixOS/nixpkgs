{ lib
, buildPythonPackage
, numpy
, libsamplerate
, fetchFromGitHub
}:

buildPythonPackage {
  pname = "scikits-samplerate";
  version = "0.3.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "cournape";
    repo = "samplerate";
    rev = "a536c97eb2d6195b5f266ea3cc3a35364c4c2210";
    hash = "sha256-7x03Q6VXfP9p8HCk15IDZ9HeqTyi5F1AlGX/otdh8VU=";
  };

  buildInputs =  [
    libsamplerate
  ];

  propagatedBuildInputs = [
    numpy
  ];

  preConfigure = ''
     cat > site.cfg << END
     [samplerate]
     library_dirs=${libsamplerate.out}/lib
     include_dirs=${lib.getDev libsamplerate}/include
     END
  '';

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/cournape/samplerate";
    description = "High quality sampling rate convertion from audio data in numpy arrays";
    license = licenses.gpl2;
  };

}
