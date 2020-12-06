{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, isPy3k
, docutils
, requests
, requests_download
, zipfile36
, pythonOlder
, pytest
, testpath
, responses
, flit-core
}:

# Flit is actually an application to build universal wheels.
# It requires Python 3 and should eventually be moved outside of
# python-packages.nix. When it will be used to build wheels,
# care should be taken that there is no mingling of PYTHONPATH.

buildPythonPackage rec {
  pname = "flit";
  version = "3.0.0";
  disabled = !isPy3k;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "takluyver";
    repo = "flit";
    rev = version;
    sha256 = "zk6mozS3Q9U43PQe/DxgwwsBRJ6Qwb+rSUVGXHijD+g=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  # Use toml instead of pytoml
  # Resolves infinite recursion since packaging started using flit.
  patches = [
    (fetchpatch {
      url = "https://github.com/takluyver/flit/commit/b81b1da55ef0f2768413669725d2874fcb0c29fb.patch";
      sha256 = "11oNaYsm00/j2046V9C0idpSeG7TpY3JtLuxX3ZL/OI=";
    })
  ];

  propagatedBuildInputs = [
    docutils
    requests
    requests_download
    flit-core
  ] ++ lib.optionals (pythonOlder "3.6") [
    zipfile36
  ];

  checkInputs = [ pytest testpath responses ];

  # Disable test that needs some ini file.
  # Disable test that wants hg
  checkPhase = ''
    HOME=$(mktemp -d) pytest -k "not test_invalid_classifier and not test_build_sdist"
  '';

  meta = with lib; {
    description = "A simple packaging tool for simple packages";
    homepage = "https://github.com/takluyver/flit";
    license = licenses.bsd3;
    maintainers = [ maintainers.fridh ];
  };
}
