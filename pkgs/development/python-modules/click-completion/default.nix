{ stdenv, buildPythonPackage, fetchPypi, isPy3k,
  click, jinja2, shellingham, six
}:

buildPythonPackage rec {
  pname = "click-completion";
  version = "0.5.1";
  disabled = (!isPy3k);

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ysn6kzv3fgakn0y06i3cxynd8iaybarrygabk9a0pp2spn2w1vq";
  };

  propagatedBuildInputs = [ click jinja2 shellingham six ];

  meta = with stdenv.lib; {
    description = "Add or enhance bash, fish, zsh and powershell completion in Click";
    homepage = https://github.com/click-contrib/click-completion;
    license = licenses.mit;
    maintainers = with maintainers; [ mbode ];
  };
}
