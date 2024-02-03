{ lib
, buildPythonPackage
, fetchFromGitHub
, nose
}:

buildPythonPackage rec {
  version = "0.1.4";
  pname = "forbiddenfruit";

  src = fetchFromGitHub {
    owner = "clarete";
    repo = "forbiddenfruit";
    rev = version;
    sha256 = "16chhrxbbmg6lfbzm532fq0v00z8qihcsj0kg2b5jlgnb6qijwn8";
  };

  nativeCheckInputs = [ nose ];

  preBuild = ''
    export FFRUIT_EXTENSION="true";
  '';

  # https://github.com/clarete/forbiddenfruit/pull/47 required to switch to pytest
  checkPhase = ''
    find ./build -name '*.so' -exec mv {} tests/unit \;
    nosetests
  '';

  meta = with lib; {
    description = "Patch python built-in objects";
    homepage = "https://github.com/clarete/forbiddenfruit";
    license = licenses.mit;
  };

}
