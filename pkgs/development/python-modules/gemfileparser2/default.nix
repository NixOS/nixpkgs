{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "gemfileparser2";
  version = "0.9.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BFKJZOf0W2b0YNbKIwnrmoKGvtP8A6R9PrUt7kYC/Dk=";
  };

  dontConfigure = true;

  postPatch = ''
    # https://github.com/nexB/gemfileparser2/pull/8
    substituteInPlace setup.cfg \
      --replace ">=3.6.*" ">=3.6"
  '';

  nativeBuildInputs = [ setuptools-scm ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "gemfileparser2" ];

  meta = with lib; {
    description = "Library to parse Rubygem gemspec and Gemfile files";
    homepage = "https://github.com/nexB/gemfileparser2";
    changelog = "https://github.com/nexB/gemfileparser2/blob/v${version}/CHANGELOG.rst";
    license = with licenses; [
      mit # or
      gpl3Plus
    ];
    maintainers = with maintainers; [ harvidsen ];
  };
}
