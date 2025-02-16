{
  lib,
  buildPythonPackage,
  python3Packages,
  fetchFromGitHub,
  fetchpatch,
}:

buildPythonPackage rec {
  pname = "helium";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "mherrmann";
    repo = "helium";
    rev = "v${version}";
    hash = "sha256-YV/X7BBzmX/4QL+YHJZrZPPsvZ2VheNHZiUrF/lUTW8=";
  };

  # fix start_firefox 'profile' parameter: see https://github.com/mherrmann/helium/pull/132
  patches = [
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/mherrmann/helium/pull/132.patch";
      hash = "sha256-jdFjq5MfMHHG+LEFr8udXvvKW3ojA3HmVBTpLJf+EGw=";
    })
  ];

  dependencies = [
    python3Packages.selenium
  ];

  meta = {
    description = "Lighter web automation with Python";
    homepage = "https://github.com/mherrmann/helium";
    changelog = "https://github.com/mherrmann/helium/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.joblade
    ];
  };
}
