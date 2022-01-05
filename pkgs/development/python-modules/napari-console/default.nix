{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools-scm
, pytestCheckHook
, pytest
, ipython
, ipykernel
, qtconsole
, napari-plugin-engine
, imageio
}: buildPythonPackage rec {
  pname = "napari-console";
  version = "0.0.4";
  src = fetchFromGitHub {
    owner = "napari";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-aVdYOzkZ+dqB680oDjNCg6quXU+QgUZI09E/MSTagyA=";
  };
  nativeBuildInputs = [ setuptools-scm ];
  # setup.py somehow requires pytest
  propagatedBuildInputs = [ pytest ipython ipykernel napari-plugin-engine imageio qtconsole ];
  chechInputs = [ pytestCheckHook ];
  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  meta = with lib; {
    description = "A plugin that adds a console to napari";
    homepage = "https://github.com/napari/napari-console";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
