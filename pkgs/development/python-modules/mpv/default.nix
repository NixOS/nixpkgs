{ stdenv, buildPythonPackage, fetchFromGitHub, pkgs, youtube-dl }:

buildPythonPackage rec {
  name = "mpv-${version}";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "jaseg";
    repo = "python-mpv";
    rev = "v${version}";
    sha256 = "0rf1yinqql9y3h9r3pdcziqjn23dqcwyk26xwrbi38zhqck2s146";
  };

  buildInputs = [ pkgs.mpv ];

  propagatedBuildInputs = [ youtube-dl ];

  patchPhase = ''
    substituteInPlace mpv.py \
      --replace "ctypes.util.find_library('mpv')" '"${pkgs.mpv}/lib/libmpv.so"'
  '';

  # no tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A python interface to the mpv media player";
    homepage = src.meta.homepage;
    license = licenses.agpl3;
  };

}
