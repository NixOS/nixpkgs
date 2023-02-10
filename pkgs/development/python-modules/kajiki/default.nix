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
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "jackrosenthal";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-bdQBVFHRB408/7X9y+3+fpllhymFRsdv/MEPTVjJh2E=";
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
