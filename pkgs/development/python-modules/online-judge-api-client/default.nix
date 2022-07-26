{ lib
, appdirs
, beautifulsoup4
, buildPythonPackage
, colorlog
, fetchFromGitHub
, git
, jsonschema
, lxml
, markdown
, python
, requests
, substituteAll
, toml
}:

let
  # NOTE This is needed to download & run another Python program internally in
  #      order to generate test cases for library-checker problems.
  pythonEnv = python.withPackages (ps: with ps; [ colorlog jinja2 markdown toml ]);
in buildPythonPackage rec {
  pname = "online-judge-api-client";
  version = "10.10.0";

  src = fetchFromGitHub {
    owner = "online-judge-tools";
    repo = "api-client";
    rev = "v${version}";
    sha256 = "0lmryqi0bv82v9k9kf1rzzq9zr83smpmy8ivzw4fk31hvpczp4fn";
  };

  patches = [ ./fix-paths.patch ];
  postPatch = ''
    substituteInPlace onlinejudge/service/library_checker.py \
      --subst-var-by git               ${git} \
      --subst-var-by pythonInterpreter ${pythonEnv.interpreter}
  '';

  propagatedBuildInputs = [
    appdirs
    beautifulsoup4
    colorlog
    jsonschema
    lxml
    requests
    toml
  ];

  # Requires internet access
  doCheck = false;

  pythonImportsCheck = [ "onlinejudge" "onlinejudge_api" ];

  meta = with lib; {
    description = "API client to develop tools for competitive programming";
    homepage = "https://github.com/online-judge-tools/api-client";
    license = licenses.mit;
    maintainers = with maintainers; [ sei40kr ];
  };
}
