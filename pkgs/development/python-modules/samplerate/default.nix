{ stdenv
, buildPythonPackage
, numpy
, pkgs
}:

buildPythonPackage {
  pname = "scikits.samplerate";
  version = "0.3.3";

  src = pkgs.fetchgit {
    url = https://github.com/cournape/samplerate;
    rev = "a536c97eb2d6195b5f266ea3cc3a35364c4c2210";
    sha256 = "0mgic7bs5zv5ji05vr527jlxxlb70f9dg93hy1lzyz2plm1kf7gg";
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

  meta = with stdenv.lib; {
    homepage = https://github.com/cournape/samplerate;
    description = "High quality sampling rate convertion from audio data in numpy arrays";
    license = licenses.gpl2;
  };

}
