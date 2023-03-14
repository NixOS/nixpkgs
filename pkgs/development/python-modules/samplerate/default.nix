{ lib
, buildPythonPackage
, numpy
, pkgs
, fetchFromGitHub
}:

buildPythonPackage {
  pname = "scikits.samplerate";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "cournape";
    repo = "samplerate";
    rev = "a536c97eb2d6195b5f266ea3cc3a35364c4c2210";
    sha256 = "sha256-7x03Q6VXfP9p8HCk15IDZ9HeqTyi5F1AlGX/otdh8VU=";
  };

  buildInputs =  [ pkgs.libsamplerate ];
  propagatedBuildInputs = [ numpy ];

  preConfigure = ''
     cat > site.cfg << END
     [samplerate]
     library_dirs=${pkgs.libsamplerate.out}/lib
     include_dirs=${pkgs.libsamplerate.dev}/include
     END
  '';

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/cournape/samplerate";
    description = "High quality sampling rate convertion from audio data in numpy arrays";
    license = licenses.gpl2;
  };

}
