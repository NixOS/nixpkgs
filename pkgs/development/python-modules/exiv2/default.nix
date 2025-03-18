{
  lib,
  pkg-config,
  exiv2,
  python3Packages,
  fetchFromGitHub,
  gitUpdater,
}:
python3Packages.buildPythonPackage rec {
  pname = "exiv2";
  version = "0.16.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jim-easterbrook";
    repo = "python-exiv2";
    rev = "refs/tags/${version}";
    hash = "sha256-DX0pg80fOSkWqrIvcye0btZGglnizzM9ZEuVEpnEJKQ=";
  };

  build-system = with python3Packages; [
    setuptools
    toml
  ];
  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ exiv2 ];

  pythonImportsCheck = [ "exiv2" ];
  nativeCheckInputs = with python3Packages; [ unittestCheckHook ];
  unittestFlagsArray = [
    "-s"
    "tests"
    "-v"
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Low level Python interface to the Exiv2 C++ library";
    homepage = "https://github.com/jim-easterbrook/python-exiv2";
    changelog = "https://python-exiv2.readthedocs.io/en/release-${version}/misc/changelog.html";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ zebreus ];
  };
}
