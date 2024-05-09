{ lib
, fetchpatch
, buildPythonPackage
, fetchFromGitHub

, matplotlib
, setuptools-scm
, pytest
}:

buildPythonPackage rec {
  pname = "mplcursors";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "anntzer";
    repo = "mplcursors";
    rev = "v${version}";
    hash = "sha256-qtFhSl7ZThAsXXOs1I9dk/ymlwNjr6rHmN6lItX9CdE=";
  };

  # This package uses setuptools-scm to derive the version from the git repo (which we don't have),
  # so use this environment variable to set it manually instead.
  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    matplotlib
    setuptools-scm
  ];

  meta = with lib; {
    description = "Interactive data selection cursors for Matplotlib";
    homepage = "https://mplcursors.readthedocs.io";
    license = licenses.zlib;
    maintainers = with maintainers; [ chpatrick nh2 ];
  };
}
