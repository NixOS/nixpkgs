{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  setuptools,

  spylls,
}:

buildPythonPackage rec {
  pname = "phunspell";
  version = "0.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dvwright";
    repo = "phunspell";
    rev = "refs/tags/v${version}";
    hash = "sha256-TlO9Ccr2iRN+s3JV+3P36RF9oFY32fj+24sKslZZCVk=";
  };

  patches = [
    (fetchpatch {
      name = "fix-package-data-warning.patch";
      url = "https://github.com/dvwright/phunspell/commit/70a0ee8af8442797e03916cea31637c21e6d32d9.patch";
      hash = "sha256-kSaKHd7dVJM8+2dqxjs26Hv0feNXAXXymUE97DNVBFM=";
    })
    (fetchpatch {
      name = "replace-description-file-deprecated-option.patch";
      url = "https://github.com/dvwright/phunspell/commit/331c593b486cebe1a9b72befa568de9b51033f15.patch";
      hash = "sha256-gdYfeG1vBtjnDDCjmg+ZSuToqVe0hrzB3RIqBLGNvBQ=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [ spylls ];

  # for tests need lots of RAM, just skip...
  doCheck = false;

  pythonImportsCheck = [ "phunspell" ];

  meta = with lib; {
    description = "Pure Python spell checker, wrapping spylls a port of Hunspell";
    homepage = "https://github.com/dvwright/phunspell";
    changelog = "https://github.com/dvwright/phunspell/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ vizid ];
  };
}
