{ lib, stdenv, buildPythonPackage, fetchFromGitHub, python, isPy27
, mpv
}:

buildPythonPackage rec {
  pname = "mpv";
  version = "1.0.1";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "jaseg";
    repo = "python-mpv";
    rev = "v${version}";
    hash = "sha256-UCJ1PknnWQiFciTEMxTUqDzz0Z8HEWycLuQqYeyQhoM=";
  };

  buildInputs = [ mpv ];

  postPatch = ''
    substituteInPlace mpv.py \
      --replace "sofile = ctypes.util.find_library('mpv')" \
                'sofile = "${mpv}/lib/libmpv${stdenv.targetPlatform.extensions.sharedLibrary}"'
  '';

  # tests impure, will error if it can't load libmpv.so
  doCheck = false;
  pythonImportsCheck = [ "mpv" ];

  meta = with lib; {
    description = "A python interface to the mpv media player";
    homepage = "https://github.com/jaseg/python-mpv";
    license = licenses.agpl3Plus;
  };
}
