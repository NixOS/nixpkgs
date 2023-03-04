{ lib
, buildPythonPackage
, fetchFromGitHub
, babel
, pytz
, nine
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "kajiki";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "jackrosenthal";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-EbXe4Jh2IKAYw9GE0kFgKVv9c9uAOiFFYaMF8CGaOfg=";
  };

  propagatedBuildInputs = [ babel pytz nine ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Kajiki provides fast well-formed XML templates";
    homepage = "https://github.com/nandoflorestan/kajiki";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };

}
