{ lib
, buildPythonPackage
, fetchFromGitHub
, audio-metadata
, multidict
, poetry
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "google-music-utils";
  version = "2.5.0";

  # Pypi tarball doesn't contain tests
  src = fetchFromGitHub {
    owner = "thebigmunch";
    repo = "google-music-utils";
    rev = version;
    sha256 = "0vwbrgakk23fypjspmscz4gllnb3dksv2njy4j4bm8vyr6fwbi5f";
  };
  format = "pyproject";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'multidict = "^4.0"' 'multidict = ">4.0"'
  '';

  nativeBuildInputs = [ poetry ];

  propagatedBuildInputs = [ audio-metadata multidict ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/thebigmunch/google-music-utils";
    description = "A set of utility functionality for google-music and related projects";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
