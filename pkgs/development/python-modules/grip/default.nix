{ stdenv
, fetchFromGitHub
, fetchpatch
# Python bits:
, buildPythonPackage
, pytest
, responses
, docopt
, flask
, markdown
, path-and-address
, pygments
, requests
, tabulate
}:

buildPythonPackage rec {
  pname = "grip";
  version = "4.5.2";

  src = fetchFromGitHub {
    owner = "joeyespo";
    repo = "grip";
    rev = "v${version}";
    sha256 = "0hphplnyi903jx7ghfxplg1qlj2kpcav1frr2js7p45pbh5ib9rm";
  };

  patches = [
    # Render "front matter", used in our RFC template and elsewhere
    (fetchpatch {
      url = https://github.com/joeyespo/grip/pull/249.patch;
      sha256 = "07za5iymfv647dfrvi6hhj54a96hgjyarys51zbi08c51shqyzpg";
    })
  ];

  checkInputs = [ pytest responses ];

  propagatedBuildInputs = [ docopt flask markdown path-and-address pygments requests tabulate ];

  checkPhase = ''
      export PATH="$PATH:$out/bin"
      py.test -xm "not assumption"
  '';

  meta = with stdenv.lib; {
    description = "Preview GitHub Markdown files like Readme locally before committing them";
    homepage = https://github.com/joeyespo/grip;
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
  };
}
