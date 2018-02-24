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
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "joeyespo";
    repo = "grip";
    rev = "v${version}";
    sha256 = "1768n3w40qg1njkzqjyl5gkva0h31k8h250821v69imj1zimymag";
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
