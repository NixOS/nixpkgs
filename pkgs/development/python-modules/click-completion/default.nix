{ lib, buildPythonPackage, fetchFromGitHub, isPy3k,
  click, jinja2, shellingham, six
}:

buildPythonPackage rec {
  pname = "click-completion";
  version = "0.5.2";
  disabled = (!isPy3k);

  src = fetchFromGitHub {
     owner = "click-contrib";
     repo = "click-completion";
     rev = "v0.5.2";
     sha256 = "17wpygrbd7xfb8mrbl9v2v4vljapcjbgp787imi5cgff01r242k7";
  };

  propagatedBuildInputs = [ click jinja2 shellingham six ];

  meta = with lib; {
    description = "Add or enhance bash, fish, zsh and powershell completion in Click";
    homepage = "https://github.com/click-contrib/click-completion";
    license = licenses.mit;
    maintainers = with maintainers; [ mbode ];
  };
}
