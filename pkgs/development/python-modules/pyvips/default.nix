{ buildPythonPackage, fetchFromGitHub, pytestCheckHook, glib, vips, cffi
, pkgconfig, lib }:

buildPythonPackage rec {
  pname = "pyvips";
  version = "2.1.16";

  src = fetchFromGitHub {
    owner = "libvips";
    repo = "pyvips";
    rev = "v${version}";
    sha256 = "sha256-8CeQbx3f2i0lEU0wxPeUwHlUGtzOztzTOdFNjIDy8s0=";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ glib vips ];

  propagatedBuildInputs = [ cffi ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyvips" ];

  meta = with lib; {
    description = "A python wrapper for libvips";
    homepage = "https://github.com/libvips/pyvips";
    license = licenses.mit;
    maintainers = with maintainers; [ ccellado ];
  };
}
