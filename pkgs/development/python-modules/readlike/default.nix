{ lib
, buildPythonPackage
, fetchFromGitHub
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "readlike";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "jangler";
    repo = "readlike";
    rev = version;
    sha256 = "1mw8j8ads8hqdbz42siwpffi4wi5s33z9g14a5c2i7vxp8m68qc1";
  };

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [ "-s" "tests" ];

  meta = with lib; {
    description = "GNU Readline-like line editing module";
    homepage = "https://github.com/jangler/readlike";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
