{
  lib,
  pkg-config,
  exiv2,
  gettext,
  fetchFromGitHub,
  gitUpdater,
  buildPythonPackage,
  setuptools,
  toml,
  pytestCheckHook,
  fetchpatch,
}:
buildPythonPackage rec {
  pname = "exiv2";
  version = "0.18.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jim-easterbrook";
    repo = "python-exiv2";
    tag = version;
    hash = "sha256-lYz0TWiiBtpwZ56Oiy2v8DFBXoofMv60hxsG0q7Cx9Y=";
  };

  patches = [
    # Disable refcount tests for python >= 3.14
    (fetchpatch {
      url = "https://github.com/jim-easterbrook/python-exiv2/commit/fe98ad09ff30f1b6cc5fd5dcc0769f9505c09166.patch";
      hash = "sha256-+KepYfzocG6qkak+DwXFtCaMiLEAE+FegONgL4vo21o=";
    })
    (fetchpatch {
      url = "https://github.com/jim-easterbrook/python-exiv2/commit/e0a5284620e8d020771bf8c1fa73d6113e662ebf.patch";
      hash = "sha256-n/yfhP/Z4Is/+2bKsFZtcNXnQe61DjoE9Ryi2q9yTSA=";
    })
  ];

  build-system = [
    setuptools
    toml
  ];
  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    exiv2
    gettext
  ];

  pythonImportsCheck = [ "exiv2" ];
  nativeCheckInputs = [ pytestCheckHook ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Low level Python interface to the Exiv2 C++ library";
    homepage = "https://github.com/jim-easterbrook/python-exiv2";
    changelog = "https://python-exiv2.readthedocs.io/en/release-${version}/misc/changelog.html";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ zebreus ];
  };
}
