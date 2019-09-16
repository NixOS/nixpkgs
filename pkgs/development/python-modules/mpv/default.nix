{ stdenv, buildPythonPackage, fetchFromGitHub, python, isPy27
, mpv
}:

buildPythonPackage rec {
  pname = "mpv";
  version = "0.3.9";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "jaseg";
    repo = "python-mpv";
    rev = "v${version}";
    sha256 = "112kr9wppcyy3shsb7v7kq0s1pdw6vw3v2fvqicm7qb2f49y2p4q";
  };

  buildInputs = [ mpv ];

  postPatch = ''
    substituteInPlace mpv.py \
      --replace "sofile = ctypes.util.find_library('mpv')" \
                'sofile = "${mpv}/lib/libmpv${stdenv.targetPlatform.extensions.sharedLibrary}"'
  '';

  # tests impure, will error if it can't load libmpv.so
  checkPhase = "${python.interpreter} -c 'import mpv'";

  meta = with stdenv.lib; {
    description = "A python interface to the mpv media player";
    homepage = "https://github.com/jaseg/python-mpv";
    license = licenses.agpl3;
  };
}
