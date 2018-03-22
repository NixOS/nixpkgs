{ buildPythonPackage, fetchFromGitHub, isPy3k, lxml, html5lib, nose, stdenv }:

buildPythonPackage rec {
  version = "v0.1.2";
  pname = "htmltreediff";

  disabled = isPy3k;

  src = fetchFromGitHub {
    owner = "christian-oudard";
    repo = pname;
    rev = version;
    sha256 = "16mqp2jyznrw1mgd3qzybq28h2k5wz7vmmz1m6xpgscazyjhvvd1";
  };

  propagatedBuildInputs = [ lxml html5lib ];

  checkInputs = [ nose ];

  meta = with stdenv.lib; {
    description = " Structure-aware diff for html and xml documents";
    homepage = https://github.com/christian-oudard/htmltreediff;
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ ma27 ];
  };
}
