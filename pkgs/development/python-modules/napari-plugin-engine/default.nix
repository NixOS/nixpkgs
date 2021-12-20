{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools-scm
, pytestCheckHook
}: buildPythonPackage rec {
  pname = "napari-plugin-engine";
  version = "0.2.0";
  src = fetchFromGitHub {
    owner = "napari";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cKpCAEYYRq3UPje7REjzhEe1J9mmrtXs8TBnxWukcNE=";
  };
  nativeBuildInputs = [ setuptools-scm ];
  checkInputs = [ pytestCheckHook ];
  doCheck = false;
  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  meta = with lib; {
    description = "A fork of pluggy for napari - plugin management package";
    homepage = "https://github.com/napari/napari-plugin-engine";
    license = licenses.mit;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
