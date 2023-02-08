{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools-scm
, pytestCheckHook
, vispy
, napari-plugin-engine
, imageio
}: buildPythonPackage rec {
  pname = "napari-svg";
  version = "0.1.5";
  src = fetchFromGitHub {
    owner = "napari";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-20NLi6JTugP+hxqF2AnhSkuvhkGGbeG+tT3M2SZbtRc=";
  };
  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ vispy napari-plugin-engine imageio ];
  nativeCheckInputs = [ pytestCheckHook ];
  doCheck = false; # Circular dependency: napari
  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  meta = with lib; {
    description = "A plugin for writing svg files from napari";
    homepage = "https://github.com/napari/napari-svg";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
