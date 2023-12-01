{ stdenv
, lib
, fetchgit
}:
stdenv.mkDerivation rec {
  pname = "libnut";
  version = "unstable-2020-11-06";

  src = fetchgit {
    url = "https://git.ffmpeg.org/nut.git";
    rev = "12f6a7af3e0f34fd957cf078b66f072d3dc695b3";
    sha256 = "1wgl2mb9482c1j3yac0v2ilfjs7gb9mhw9kjnrmlj9kp0whm4l1j";
  };

  sourceRoot = "${src.name}/src/trunk";
  makeFlags = ["prefix=$(out)"];
  installTargets = [
    "install-libnut"
    "install-nututils"
  ];

  meta = with lib; {
    description = "A library to read/write the NUT video container format";
    homepage = "https://git.ffmpeg.org/gitweb/nut.git";
    license = licenses.mit;
    maintainers = with maintainers; [quag];
    platforms = platforms.linux;
  };
}
