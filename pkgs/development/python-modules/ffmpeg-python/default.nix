{ lib
, buildPythonPackage
, fetchPypi
, ffmpeg
, future
}:

buildPythonPackage rec {
  pname = "ffmpeg-python";
  version = "0.2.0";

  src = fetchPypi {
    sha256 = "09s19kvgc4f0g05z3xjj8w15xcwbabmv3j0i1vppii978srms8k5";
    inherit pname version;
  };

  buildInputs = [ future ];

  postFixup = ''
    substituteInPlace $out/lib/python*/site-packages/ffmpeg/_run.py \
      --replace "cmd='ffmpeg'" "cmd='${ffmpeg}/bin/ffmpeg'"

    substituteInPlace $out/lib/python*/site-packages/ffmpeg/_probe.py \
      --replace "cmd='ffprobe'" "cmd='${ffmpeg}/bin/ffprobe'"
  '';

  doCheck = false;

  meta = with lib; {
    description = "Python bindings for FFmpeg - with complex filtering support";
    homepage = https://github.com/kkroening/ffmpeg-python;
    license = "apache";
    maintainers = [ maintainers.nrdxp ];
  };
}
