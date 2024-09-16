{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  beautifulsoup4,
  ipython,
  ipywidgets,
  lxml,
  matplotlib,
  mysql-connector,
  numpy,
  pandas,
  protobuf,
  requests,
  tqdm,
}:

buildPythonPackage rec {
  pname = "gget";
  version = "0.28.6";

  src = fetchFromGitHub {
    owner = "pachterlab";
    repo = "gget";
    rev = "v${version}";
    hash = "sha256-Y6rKrl+Ls4uyIH1RxOsCkfh21xx9s52XtIKgZnXk8wA=";
  };

  patches = [
    (fetchpatch {
      name = "allow-using-newer-mysql-connector-versions.patch";
      url = "https://github.com/pachterlab/gget/commit/49c24c592061764c18b38ef4205409191a548e12.patch";
      hash = "sha256-m8RwiTJ6YMIfR2LzdBIeB6JO2iL7WX7kNowFPp2Rz38=";
    })
    (fetchpatch {
      name = "fix-setup-warns-and-errs.patch";
      url = "https://github.com/pachterlab/gget/compare/main...d559bb5c4cbb2864828861e0881900131717a6c0.patch";
      hash = "sha256-Xz4vR9qyWtbyzyPnSB+RHIAIfXJtF9BugJy39AuRVTk=";
    })
  ];

  pyproject = true;
  build-system = [ setuptools ];
  dependencies = [
    beautifulsoup4
    ipython
    ipywidgets
    lxml
    matplotlib
    mysql-connector
    numpy
    pandas
    protobuf
    requests
    tqdm
  ];

  env.MPLCONFIGDIR = "/tmp/.config/matplotlib";
}
