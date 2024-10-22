{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:
buildPythonPackage rec {
  pname = "mpegdash";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sangwonl";
    repo = "python-mpegdash";
    rev = version;
    hash = "sha256-eKtJ+QzeoMog5X1r1ix9vrmGTi/9KzdJiu80vrTX14I=";
  };

  nativeBuildInputs = [ setuptools ];
  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # requires network access
    "test_xml2mpd_from_url"
  ];

  pythonImportsCheck = [ "mpegdash" ];

  meta = {
    description = "MPEG-DASH MPD(Media Presentation Description) Parser";
    homepage = "https://github.com/sangwonl/python-mpegdash";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drawbu ];
  };
}
