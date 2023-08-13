{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, pytest
}:

buildPythonPackage rec {
  pname = "coordinates";
  version = "0.4.0";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "clbarnes";
    repo = "coordinates";
    rev = "v${version}";
    sha256 = "1zha594rshjg3qjq9mrai2hfldya282ihasp2i3km7b2j4gjdw2b";
  };

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    runHook preCheck
    pytest tests/
    runHook postCheck
  '';

  meta = with lib; {
    description = "Convenience class for doing maths with explicit coordinates";
    homepage = "https://github.com/clbarnes/coordinates";
    license = licenses.mit;
    maintainers = [ ];
  };
}
