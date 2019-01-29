{ stdenv, buildPythonPackage, fetchPypi, isPy3k,
  click, jinja2, shellingham, six
}:

buildPythonPackage rec {
  pname = "click-completion";
  version = "0.5.0";
  disabled = (!isPy3k);

  src = fetchPypi {
    inherit pname version;
    sha256 = "0k3chs301cnyq2jfl12lih5fa6r06nmxmbyp9dwvjm09v8f2c03n";
  };

  propagatedBuildInputs = [ click jinja2 shellingham six ];

  meta = with stdenv.lib; {
    description = "Add or enhance bash, fish, zsh and powershell completion in Click";
    homepage = https://github.com/click-contrib/click-completion;
    license = licenses.mit;
    maintainers = with maintainers; [ mbode ];
  };
}
