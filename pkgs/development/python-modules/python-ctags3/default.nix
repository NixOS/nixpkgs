{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "python-ctags3";
  version = "1.5.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "universal-ctags";
    repo = pname;
    rev = version;
    hash = "sha256-XVsZckNVJ1H5q8FzqoVd1UWRw0zOygvRtb7arX9dwGE=";
  };

  nativeBuildInputs = [ cython ];

  # Regenerating the bindings keeps later versions of Python happy
  postPatch = ''
    cython src/_readtags.pyx
  '';

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Ctags indexing python bindings";
    license = licenses.lgpl3Plus;
  };
}
